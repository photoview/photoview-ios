//
//  MediaThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct MediaThumbnailView: View {
  let thumbnail: String?
  
  var body: some View {
    GeometryReader { geo in
      ProtectedImageView(url: thumbnail) { image in
        AnyView(
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
        )
      }
      .frame(height: geo.size.width)
    }
    .clipped()
    .aspectRatio(1, contentMode: .fit)
  }
}

struct MediaThumbnailView_Previews: PreviewProvider {
  static var previews: some View {
    MediaThumbnailView(thumbnail: nil)
  }
}
