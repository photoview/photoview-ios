//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AlbumsScreen: View {
  
  @EnvironmentObject var showWelcome: ShowWelcomeScreen
  @State var albumData: [MyAlbumsQuery.Data.MyAlbum] = []
  
  func fetchMyAlbums() {
    Network.shared.apollo?.fetch(query: MyAlbumsQuery()) { result in
      switch(result) {
      case let .success(data):
        DispatchQueue.main.async {
          // albumData = data.data?.album
          albumData = data.data?.myAlbums ?? []
        }
      case let .failure(error):
        Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch my albums", error: error), showWelcomeScreen: showWelcome)
      }
    }
  }
  
  var body: some View {
    NavigationView {
      if let albums = albumData {
        ScrollView(.vertical, showsIndicators: true) {
          LazyVGrid(columns: AlbumGrid.albumColumns, alignment: .leading, spacing: 20) {
            ForEach(albums, id: \.id) { album in
              AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, destination: AlbumView(albumID: album.id, albumTitle: album.title))
            }
          }
          .padding(.horizontal)
          .navigationTitle("My albums")
        }
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
