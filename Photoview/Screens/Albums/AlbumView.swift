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
  
  func fetchAlbum() {
    Network.shared.apollo?.fetch(query: AlbumViewSingleAlbumQuery(albumID: albumID)) { result in
      switch(result) {
      case .success(let data):
        DispatchQueue.main.async {
          albumData = data.data?.album
          
          if let album = data.data?.album {
            mediaDetailsEnv.media = try! album.media.map(MediaEnvironment.Media.from)
          } else {
            mediaDetailsEnv.media = []
          }
        }
      case .failure(let error):
        Network.shared.handleGraphqlError(error: error, showWelcomeScreen: showWelcome, message: "Failed to fetch album: \(albumID)")
      }
    }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        AlbumGrid(album: albumData)
        MediaGrid()
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
