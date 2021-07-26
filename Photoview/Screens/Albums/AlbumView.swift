//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import Apollo

class MediaEnvironment: ObservableObject {
  @Published var album: AlbumViewSingleAlbumQuery.Data.Album?
  @Published var activeMediaIndex: Int
  @Published var fullScreen: Bool = false
  
  var activeMedia: AlbumViewSingleAlbumQuery.Data.Album.Medium? {
    album?.media[activeMediaIndex]
  }
  
  init(album: AlbumViewSingleAlbumQuery.Data.Album?, activeMediaIndex: Int) {
    self.album = album
    self.activeMediaIndex = activeMediaIndex
  }
}

struct AlbumView: View {
  let albumID: String
//  @State var albumData: AlbumViewSingleAlbumQuery.Data.Album? = nil
  
  @StateObject var mediaDetailsEnv: MediaEnvironment = MediaEnvironment(album: nil, activeMediaIndex: 0)
  
  func fetchAlbum() {
    Network.shared.apollo?.fetch(query: AlbumViewSingleAlbumQuery(albumID: albumID)) { result in
      switch(result) {
      case .success(let data):
        DispatchQueue.main.async {
          mediaDetailsEnv.album = data.data?.album
        }
      case .failure(let error):
        fatalError("Graphql error: \(error)")
      }
    }
  }
  
  var body: some View {
    let albumColumns = [GridItem(.adaptive(minimum: 140), alignment: .center)]
    let mediaColumns = [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 4, alignment: .center)]
    
    ScrollView {
      VStack(spacing: 20) {
        LazyVGrid(columns: albumColumns, alignment: .leading, spacing: 20) {
          ForEach(mediaDetailsEnv.album?.subAlbums ?? [], id: \.id) { album in
            AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, destination: AlbumView(albumID: album.id))
          }
        }.padding(.horizontal)
        
        LazyVGrid(columns: mediaColumns, alignment: .leading, spacing: 4) {
          ForEach(0 ..< (mediaDetailsEnv.album?.media.count ?? 0), id: \.self) { index in
            MediaThumbnailView(index: index)
          }
        }
      }
    }.onAppear {
      if mediaDetailsEnv.album == nil {
        fetchAlbum()
      }
    }
    .navigationTitle(mediaDetailsEnv.album?.title ?? "Loading album")
    .environmentObject(mediaDetailsEnv)
  }
}

struct AlbumView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AlbumView(albumID: "")
    }
  }
}
