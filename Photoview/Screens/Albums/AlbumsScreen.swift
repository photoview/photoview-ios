//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AlbumsScreen: View {
  
  @State var albumData: [MyAlbumsQuery.Data.MyAlbum] = []
  
  func fetchMyAlbums() {
    Network.shared.apollo?.fetch(query: MyAlbumsQuery()) { result in
      switch(result) {
      case .success(let data):
        DispatchQueue.main.async {
          // albumData = data.data?.album
          albumData = data.data?.myAlbums ?? []
        }
      case .failure(let error):
        fatalError("Graphql error: \(error)")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      if let album = albumData.first {
        AlbumView(albumID: album.id, albumTitle: album.title)
      } else {
        ProgressView("Loading albums")
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      if (albumData.isEmpty) {
        fetchMyAlbums()
      }
    }
  }
}

struct AlbumsScreen_Previews: PreviewProvider {
  static var previews: some View {
    TabView {
      AlbumsScreen()
    }
  }
}
