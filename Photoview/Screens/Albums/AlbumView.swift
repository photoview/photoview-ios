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
    let columns = [GridItem(.adaptive(minimum: 140), alignment: .center)]
    
    ScrollView {
      LazyVGrid(columns: columns, alignment: .leading) {
        ForEach(albumData?.subAlbums ?? [], id: \.id) { album in
          AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, destination: AlbumView(albumID: album.id))
        }
      }.padding(.horizontal)
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
