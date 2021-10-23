//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import Apollo

class MediaEnvironment: ObservableObject {
  
  struct Media: Decodable {
    var id: GraphQLID
    var thumbnail: Thumbnail?
    var favorite: Bool
    
    struct Thumbnail: Decodable {
      var url: String
      var width: Int
      var height: Int
    }
    
    static func from(graphql: GraphQLSelectionSet) throws -> Self {
      let data = try JSONSerialization.data(withJSONObject: graphql.jsonObject, options: [])
      let media = try JSONDecoder().decode(Media.self, from: data)
      
      return media
    }
  }
  
  @Published var media: [Media]?
  @Published var activeMediaIndex: Int
  @Published var fullScreen: Bool = false
  
  var activeMedia: Media? {
    media?[activeMediaIndex]
  }
  
  init(media: [Media]?, activeMediaIndex: Int) {
    self.media = media
    self.activeMediaIndex = activeMediaIndex
  }
  
  init() {
    self.media = nil
    self.activeMediaIndex = 0
  }
}

struct AlbumView: View {
  let albumID: String
  let albumTitle: String
  
  @EnvironmentObject var showWelcome: ShowWelcomeScreen
  @State var albumData: AlbumViewSingleAlbumQuery.Data.Album? = nil
  @StateObject var mediaDetailsEnv: MediaEnvironment = MediaEnvironment()
  
  @State var offset = 0
  let limit = 200
  @State var moreToLoad = true
  @State var loading = false
  
  func fetchAlbum() {
    mediaDetailsEnv.media = []
    mediaDetailsEnv.activeMediaIndex = 0
    offset = 0
    moreToLoad = true
    loadMore()
  }
  
  func loadMore() {
    if !moreToLoad || loading {
      return
    }
    
    loading = true
    Network.shared.apollo?.fetch(query: AlbumViewSingleAlbumQuery(albumID: albumID, limit: limit, offset: offset)) { result in
      switch(result) {
      case .success(let data):
        DispatchQueue.main.async {
          albumData = data.data?.album
          
          guard let album = data.data?.album else {
            mediaDetailsEnv.media = nil
            return
          }
          
          if album.media.isEmpty {
            moreToLoad = false
          }
          
          let newMedia = try! album.media.map(MediaEnvironment.Media.from)
          
          if var media = self.mediaDetailsEnv.media {
            media.append(contentsOf: newMedia)
            self.mediaDetailsEnv.media = media
            print("load more appended, new size: \(media.count)")
          } else {
            self.mediaDetailsEnv.media = newMedia
          }
          
          offset += limit
        }
      case .failure(let error):
        Network.shared.handleGraphqlError(error: error, showWelcomeScreen: showWelcome, message: "Failed to fetch album: \(albumID)")
      }
      DispatchQueue.main.async {
        loading = false
      }
    }
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(spacing: 20) {
        AlbumGrid(album: albumData)
        MediaGrid(onMediaAppear: {index in
          guard let mediaCount = mediaDetailsEnv.media?.count else { return }
          if mediaCount - index < 20 {
            loadMore()
          }
        })
      }
    }
    .navigationTitle(albumTitle)
    .environmentObject(mediaDetailsEnv)
    .onAppear {
      if albumData == nil {
        fetchAlbum()
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
