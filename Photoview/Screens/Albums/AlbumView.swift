//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import Apollo

struct AlbumView: View {
  let albumID: String
  @State var albumData: AlbumViewSingleAlbumQuery.Data.Album? = nil
  
  func fetchAlbum() {
    Network.shared.apollo?.fetch(query: AlbumViewSingleAlbumQuery(albumID: albumID)) { result in
      switch(result) {
      case .success(let data):
        DispatchQueue.main.async {
          albumData = data.data?.album
        }
      case .failure(let error):
        fatalError("Graphql error: \(error)")
      }
    }
  }
  
  var body: some View {
    let albumColumns = [GridItem(.adaptive(minimum: 140), alignment: .center)]
    let mediaColumns = [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: nil, alignment: .center)]
    
    ScrollView {
      VStack {
        LazyVGrid(columns: albumColumns, alignment: .leading) {
          ForEach(albumData?.subAlbums ?? [], id: \.id) { album in
            AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, destination: AlbumView(albumID: album.id))
          }
        }.padding(.horizontal)
        
        LazyVGrid(columns: mediaColumns, alignment: .leading, spacing: nil) {
          ForEach(albumData?.media ?? [], id: \.id) { media in
            MediaThumbnailView(thumbnail: media.thumbnail?.url)
          }
        }
      }
    }.onAppear {
      if albumData == nil {
        fetchAlbum()
      }
    }
    .navigationTitle(albumData?.title ?? "Loading album")
  }
}

struct AlbumView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AlbumView(albumID: "")
    }
  }
}
