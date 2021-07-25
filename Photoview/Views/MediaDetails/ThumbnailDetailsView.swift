//
//  ThumbnailDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct ThumbnailDetailsView: View {
  
  @EnvironmentObject var mediaEnv: MediaEnvironment
  
  @State var touchStarted: Bool = false
  @State var offset: CGFloat = 0
  
  func imageView(index: Int) -> some View {
    ProtectedImageView(url: mediaEnv.album?.media[index].thumbnail?.url) { uiImg in
      AnyView(
        Image(uiImage: uiImg)
          .resizable()
          .scaledToFit()
      )
    }
  }

  var imageRange: ClosedRange<Int> {
    let minVal = max(mediaEnv.activeMediaIndex - 1, 0)
    let maxVal = min(mediaEnv.activeMediaIndex + 1, mediaEnv.album!.media.count - 1)
    
    return minVal ... maxVal
  }

  let IMAGE_PADDING: CGFloat = 12
  
  func thumbnails(geo: GeometryProxy) -> some View {
    ZStack {
      ForEach(imageRange, id: \.self) { index in
        imageView(index: index)
          .offset(x: offset + CGFloat(index-mediaEnv.activeMediaIndex) * (geo.size.width + IMAGE_PADDING))
      }
    }
    .frame(width: geo.size.width)
    .gesture(
      DragGesture(minimumDistance: 30, coordinateSpace: .local)
        .onChanged({ drag in
          if touchStarted {
            offset = drag.translation.width
          } else {
            touchStarted = true
            withAnimation(Animation.spring(response: 0, dampingFraction: 1, blendDuration: 0)) {
              offset = drag.translation.width
            }
          }
        })
        .onEnded({ drag in
          let SHIFT_THRESHOLD: CGFloat = 10
          
          touchStarted = false
          
          withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0)) {
            offset = 0
            if (drag.predictedEndTranslation.width > SHIFT_THRESHOLD && mediaEnv.activeMediaIndex > 0) {
              mediaEnv.activeMediaIndex -= 1
            }
            if (drag.predictedEndTranslation.width < SHIFT_THRESHOLD && mediaEnv.activeMediaIndex + 1 < (mediaEnv.album?.media.count ?? 0)) {
              mediaEnv.activeMediaIndex += 1
            }
          }
        })
    )
  }
  
  var body: some View {
    GeometryReader { geo in
      thumbnails(geo: geo)
    }
    .aspectRatio(CGSize(width: mediaEnv.activeMedia?.thumbnail?.width ?? 3, height: mediaEnv.activeMedia?.thumbnail?.height ?? 2), contentMode: .fit)
    .padding(.horizontal, -16)
    .padding(.top, -6)
  }
}
