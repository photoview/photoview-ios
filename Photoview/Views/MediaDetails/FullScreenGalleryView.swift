//
//  FullScreenGalleryView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import SwiftUI

struct FullScreenGalleryView: View {
  @EnvironmentObject var mediaEnv: MediaEnvironment
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.black)
      ThumbnailDetailsView(fullscreenMode: true)
    }
    .ignoresSafeArea()
  }
}

struct FullScreenGalleryView_Previews: PreviewProvider {
  static var previews: some View {
    FullScreenGalleryView()
      .environmentObject(MediaDetailsView_Previews.mediaEnvironment)
  }
}
