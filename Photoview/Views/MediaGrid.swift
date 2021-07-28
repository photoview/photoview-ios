//
//  MediaGrid.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import SwiftUI

struct MediaGrid: View {
  let mediaColumns = [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 4, alignment: .center)]
  
  @EnvironmentObject var mediaEnv: MediaEnvironment
  
  var body: some View {
    LazyVGrid(columns: mediaColumns, alignment: .leading, spacing: 4) {
      ForEach(0 ..< (mediaEnv.media?.count ?? 0), id: \.self) { index in
        MediaThumbnailView(index: index)
      }
    }
  }
}

struct MediaGrid_Previews: PreviewProvider {
  static var previews: some View {
    MediaGrid()
  }
}
