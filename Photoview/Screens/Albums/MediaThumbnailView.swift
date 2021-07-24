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
    ProtectedImageView(url: thumbnail) { image in
      AnyView(
        Image(uiImage: image)
        .resizable()
      )
    }
    .aspectRatio(1, contentMode: .fill)
    .frame(minWidth: 100, idealWidth: 100, maxWidth: 140, minHeight: 100, idealHeight: 100, maxHeight: 140)
  }
}

struct MediaThumbnailView_Previews: PreviewProvider {
  static var previews: some View {
    MediaThumbnailView(thumbnail: nil)
  }
}
