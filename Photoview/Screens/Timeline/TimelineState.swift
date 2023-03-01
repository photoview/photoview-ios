//
//  TimelineState.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/02/2022.
//

import Foundation
import Combine
import Apollo

class TimelineState: ObservableObject {
    @Published var mediaEnvs: [TimelineAlbumGroup: MediaEnvironment] = [:]
    @Published var timelineAlbums: [TimelineAlbumGroup] = []
    @Published private(set) var loading = false
    
    @Published private(set) var timelineData: [TimelineQuery.Data.MyTimeline]? = nil
    private var offset = 0
    private let limit = 200
    private var moreToLoad = true
    
    private var timelineDataSink: AnyCancellable?
    
    init() {
        self.timelineDataSink = $timelineData.receive(on: RunLoop.main).sink { newValue in
            if let newValue = newValue {
                self.refreshTimeline(timelineData: newValue)
            }
        }
    }
    
    
    func fetchTimeline() async throws {
        timelineData = []
        offset = 0
        moreToLoad = true
        try await loadMore()
    }
    
    private func refreshTimeline(timelineData: [TimelineQuery.Data.MyTimeline]) {
        print("Refreshing timeline: \(timelineData.count)")
        let newTimelineAlbums = self.calculateTimelineAlbums(timelineData: timelineData)
        let newMediaEnvs = self.buildMediaEnvs(timelineAlbums: newTimelineAlbums)
        
        self.timelineAlbums = newTimelineAlbums
        self.mediaEnvs = newMediaEnvs
        print("Timeline refreshed")
    }
    
    func loadMoreIfNeeded(albumGroup: TimelineAlbumGroup, mediaIndex: Int) async throws {
        guard let timelineData = self.timelineData else {
            return
        }
        
        var mediaCount = 0
        
        for x in self.timelineAlbums {
            if x == albumGroup { break }
            mediaCount += x.media.count
        }
        
        mediaCount += mediaIndex
        
        let totalCount = timelineData.count
        
        print("Load more: \(totalCount) - \(mediaCount)")
        if totalCount - mediaCount < 20 {
            try await loadMore()
        }
    }
    
    func loadMore() async throws {
        if !moreToLoad || loading {
            return
        }
        
        guard let apollo = Network.shared.apollo else {
            return
        }
        
        loading = true
        defer { DispatchQueue.main.async { self.loading = false } }
        
        let data = try await apollo.asyncFetch(query: TimelineQuery(limit: limit, offset: offset))
        
        DispatchQueue.main.async {
            if (data.data?.myTimeline ?? []).isEmpty {
                self.moreToLoad = false
            }
            
            if var timelineData = self.timelineData {
                timelineData.append(contentsOf: data.data?.myTimeline ?? [])
                self.timelineData = timelineData
                print("load more appended, new size: \(timelineData.count)")
            } else {
                self.timelineData = data.data?.myTimeline
            }
            
            self.offset += self.limit
        }
    }
    
    // MARK: Aux functions to build timeline structure
    
    private func calculateTimelineAlbums(timelineData: [TimelineQuery.Data.MyTimeline]) -> [TimelineAlbumGroup] {
        var albums: [TimelineAlbumGroup] = []
        
        guard let firstMedia = timelineData.first else {
            return []
        }
        
        var nextAlbum: TimelineAlbumGroup = TimelineAlbumGroup(albumID: firstMedia.album.id, title: firstMedia.album.title, day: Calendar.current.startOfDay(for: firstMedia.date.date), media: [firstMedia])
        
        for media in timelineData.dropFirst() {
            let mediaDay = Calendar.current.startOfDay(for: media.date.date)
            
            if mediaDay == nextAlbum.day && media.album.id == nextAlbum.albumID {
                nextAlbum.media.append(media)
            } else {
                albums.append(nextAlbum)
                nextAlbum = TimelineAlbumGroup(albumID: media.album.id, title: media.album.title, day: Calendar.current.startOfDay(for: media.date.date), media: [media])
            }
        }
        
        albums.append(nextAlbum)
        
        return albums
    }
    
    private func buildMediaEnvs(timelineAlbums: [TimelineAlbumGroup]) -> [TimelineAlbumGroup: MediaEnvironment] {
        var result: [TimelineAlbumGroup: MediaEnvironment] = [:]
        
        for albumGroup in timelineAlbums {
            //      let media = try! albumGroup.media.map(MediaEnvironment.Media.from)
            let media = albumGroup.media.map { $0.fragments.mediaItem }
            result[albumGroup] = MediaEnvironment(media: media, activeMediaIndex: 0)
        }
        print("Finished building media envs: \(result.count)")
        return result
    }
}

struct TimelineAlbumGroup: Identifiable, Hashable {
    var id: String {
        "\(self.albumID)__\(self.day.ISO8601Format())"
    }
    
    let albumID: GraphQLID
    let title: String
    let day: Date
    var media: [TimelineQuery.Data.MyTimeline]
    
    static func == (lhs: TimelineAlbumGroup, rhs: TimelineAlbumGroup) -> Bool {
        return lhs.albumID == rhs.albumID && lhs.day == rhs.day
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(albumID)
        hasher.combine(day)
    }
}
