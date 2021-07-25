//
//  MediaThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct MediaThumbnailView: View {
  let mediaID: String
  let thumbnail: String?
  
  @State var showMediaDetailsSheet: Bool = false
  
  var thumbnailView: some View {
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
  
  var body: some View {
    Button(action: { showMediaDetailsSheet = true }) {
      thumbnailView
    }
    .sheet(isPresented: $showMediaDetailsSheet) {
      MediaDetailsView(mediaID: mediaID)
    }
  }
}

struct MediaThumbnailView_Previews: PreviewProvider {
  static var previews: some View {
    MediaThumbnailView(mediaID: "", thumbnail: nil)
  }
}
