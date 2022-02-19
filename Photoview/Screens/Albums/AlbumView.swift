//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import Apollo

class MediaEnvironment: ObservableObject {
    
    @Published var media: [MediaItem]?
    @Published var activeMediaIndex: Int?
    @Published var fullScreen: Bool = false
    
    var activeMedia: MediaItem? {
        if let activeMediaIndex = activeMediaIndex {
            return media?[activeMediaIndex]
        }
        return nil
    }
    
    init(media: [MediaItem]?, activeMediaIndex: Int) {
        self.media = media
        self.activeMediaIndex = activeMediaIndex
    }
    
    init() {
        self.media = nil
        self.activeMediaIndex = nil
    }
    
    func mediaIndex(_ media: MediaItem) -> Int {
        let index = self.media?.firstIndex { $0.id == media.id }
        return index!
    }
}

struct AlbumView: View {
    let albumID: String
    let albumTitle: String
    
    typealias AlbumQueryData = AlbumViewSingleAlbumQuery.Data.Album
    
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    @State var albumData: AlbumQueryData? = nil
    @StateObject var mediaDetailsEnv: MediaEnvironment = MediaEnvironment()
    
    @State var offset = 0
    let limit = 200
    @State var moreToLoad = true
    @State var loading = false
    
    @MainActor
    func fetchAlbum() async {
        mediaDetailsEnv.media = nil
        mediaDetailsEnv.activeMediaIndex = 0
        offset = 0
        moreToLoad = true
        await loadMore()
    }
    
    @MainActor
    func loadMore() async {
        if !moreToLoad || loading {
            return
        }
        
        guard let apollo = Network.shared.apollo else {
            return
        }
        
        loading = true
        defer { loading = false }
        
        do {
            let response = try await apollo.asyncFetch(query: AlbumViewSingleAlbumQuery(albumID: albumID, limit: limit, offset: offset))
            
            albumData = response.data?.album
            
            guard let album = response.data?.album else {
                mediaDetailsEnv.media = nil
                return
            }
            
            if album.media.isEmpty {
                moreToLoad = false
            }
            
            let newMedia = album.media.map { $0.fragments.mediaItem }
            
            if var media = self.mediaDetailsEnv.media {
                media.append(contentsOf: newMedia)
                self.mediaDetailsEnv.media = media
                print("load more appended, new size: \(media.count)")
            } else {
                self.mediaDetailsEnv.media = newMedia
            }
            
            offset += limit
        } catch {
            Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch album: \(albumID)", error: error), showWelcomeScreen: showWelcome)
        }
    }
    
    func albumItems(albums: [AlbumQueryData.SubAlbum]) -> [AlbumItem] {
        albums.map { $0.fragments.albumItem }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 20) {
                AlbumGrid(albums: albumItems(albums: albumData?.subAlbums ?? []))
                MediaGrid(onMediaAppear: { media in
                    guard let mediaCount = mediaDetailsEnv.media?.count else { return }
                    if mediaCount - mediaDetailsEnv.mediaIndex(media) < 20 {
                        Task { await loadMore() }
                    }
                })
            }
        }
        .navigationTitle(albumTitle)
        .environmentObject(mediaDetailsEnv)
        .task {
            if albumData == nil {
                await fetchAlbum()
            }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumView(albumID: "123", albumTitle: "Some title")
        }
    }
}
