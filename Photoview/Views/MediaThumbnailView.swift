//
//  MediaThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct MediaThumbnailView: View {
  let index: Int
  
  @EnvironmentObject var mediaEnv: MediaEnvironment
  
  @State var showMediaDetailsSheet: Bool = false
  
  var thumbnailView: some View {
    GeometryReader { geo in
      ProtectedImageView(url: mediaEnv.album?.media[index].thumbnail?.url) { image in
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
    Button(action: {
      mediaEnv.activeMediaIndex = index
      showMediaDetailsSheet = true
    }) {
      thumbnailView
    }
    .sheet(isPresented: $showMediaDetailsSheet) {
      MediaDetailsView()
        // can crash without this
        .environmentObject(mediaEnv)
    }
  }
}
