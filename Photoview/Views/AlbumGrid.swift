//
//  AlbumGrid.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import SwiftUI

struct AlbumGrid: View {
  static let albumColumns = [GridItem(.adaptive(minimum: 140), alignment: .center)]
  
  let albums: [AlbumItem]?
  
  var body: some View {
    LazyVGrid(columns: Self.albumColumns, alignment: .leading, spacing: 20) {
      ForEach(albums ?? [], id: \.id) { album in
          AlbumThumbnailView(title: album.title, thumbnail: album.thumbnail?.thumbnail?.url, blurhash: album.thumbnail?.blurhash, destination: AlbumView(albumID: album.id, albumTitle: album.title))
      }
    }.padding(.horizontal)
  }
}

struct AlbumGrid_Previews: PreviewProvider {
  static var previews: some View {
    AlbumGrid(albums: [])
  }
}
