//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/08/2021.
//

import SwiftUI
import Apollo

class TimelineState: ObservableObject {
  @Published var mediaEnvs: [TimelineAlbumGroup: MediaEnvironment] = [:]
  @Published var timelineAlbums: [TimelineAlbumGroup] = []
  
  func refreshTimeline(timelineData: [TimelineQuery.Data.MyTimeline]) {
    print("Refreshing timeline: \(timelineData.count)")
    let newTimelineAlbums = self.calculateTimelineAlbums(timelineData: timelineData)
    let newMediaEnvs = self.buildMediaEnvs(timelineAlbums: newTimelineAlbums)
    
    self.timelineAlbums = newTimelineAlbums
    self.mediaEnvs = newMediaEnvs
    print("Timeline refreshed")
  }
  
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
      let media = try! albumGroup.media.map(MediaEnvironment.Media.from)
      result[albumGroup] = MediaEnvironment(media: media, activeMediaIndex: 0)
    }
    print("Finished building media envs: \(result.count)")
    return result
  }
}

struct TimelineAlbumGroup: Identifiable, Hashable {
  var id: Self {
    self
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

struct TimelineView: View {
  
  let timelineData: [TimelineQuery.Data.MyTimeline]
  let loadMore: () -> Void
  @StateObject var timelineState: TimelineState = TimelineState()
  
  @State var loadedFirst = false
  
  func loadMoreIfNeeded(albumGroup: TimelineAlbumGroup, mediaIndex: Int) {
    var mediaCount = 0
    
    for x in self.timelineState.timelineAlbums {
      if x == albumGroup { break }
      mediaCount += x.media.count
    }
    
    mediaCount += mediaIndex
    
    let totalCount = timelineData.count
    
    print("Load more: \(totalCount) - \(mediaCount)")
    if totalCount - mediaCount < 20 {
      loadMore()
    }
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    
    return formatter
  }()
  
  func timelineSection(albumGroup: TimelineAlbumGroup) -> some View {
    Section(header:
      NavigationLink(destination: AlbumView(albumID: albumGroup.albumID, albumTitle: albumGroup.title)) {
        HStack {
          VStack(alignment: .leading) {
            Text(dateFormatter.string(from: albumGroup.day))
              .foregroundColor(.secondary)
            Text(albumGroup.title)
              .foregroundColor(.primary)
              .font(.headline)
          }
          Spacer()
          Image(systemName: "chevron.right")
            .foregroundColor(.secondary)
        }
      }
      .padding([.horizontal, .top])
    ) {
      if let mediaEnv = timelineState.mediaEnvs[albumGroup] {
        MediaGrid(onMediaAppear: { index in
          loadMoreIfNeeded(albumGroup: albumGroup, mediaIndex: index)
        })
          .environmentObject(mediaEnv)
      }
    }
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading) {
        ForEach(self.timelineState.timelineAlbums, id: \.id) { albumGroup in
          timelineSection(albumGroup: albumGroup)
        }
      }
    }
    .onAppear {
      self.timelineState.refreshTimeline(timelineData: self.timelineData)
    }
    .onChange(of: timelineData) { newData in
      self.timelineState.refreshTimeline(timelineData: newData)
    }
  }
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineView(timelineData: [], loadMore: {})
  }
}
