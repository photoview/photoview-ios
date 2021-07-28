//
//  AlbumGrid.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import SwiftUI

struct AlbumGrid: View {
  let albumColumns = [GridItem(.adaptive(minimum: 140), alignment: .center)]
  
//  @EnvironmentObject var mediaEnv: MediaEnvironment
  
  let album: AlbumViewSingleAlbumQuery.Data.Album?
  
  var body: some View {
    LazyVGrid(columns: albumColumns, alignment: .leading, spacing: 20) {
      ForEach(album?.subAlbums ?? [], id: \.id) { album in
        AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, destination: AlbumView(albumID: album.id))
      }
    }.padding(.horizontal)
  }
}

struct AlbumGrid_Previews: PreviewProvider {
  static var previews: some View {
    AlbumGrid(album: nil)
  }
}
