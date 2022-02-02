//
//  ThumbnailDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct ThumbnailDetailsView: View {
    
    let fullscreenMode: Bool
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    
    @State var touchStarted: Bool = false
    @State var currentOffset: CGSize = CGSize(width: 0, height: 0)
    @State var previousOffset: CGSize = CGSize(width: 0, height: 0)
    @State var currentScale: CGFloat = 1
    @State var previousScale: CGFloat = 1
    
    func imageView(index: Int) -> some View {
        ProtectedImageView(url: mediaEnv.media?[index].thumbnail?.url) { uiImg in
            AnyView(
                Image(uiImage: uiImg)
                    .resizable()
                    .scaledToFit()
            )
        }
    }
    
    var imageRange: ClosedRange<Int> {
        guard let media = mediaEnv.media else { return mediaEnv.activeMediaIndex ... mediaEnv.activeMediaIndex }
        
        let minVal = max(mediaEnv.activeMediaIndex - 1, 0)
        let maxVal = min(mediaEnv.activeMediaIndex + 1, media.count - 1)
        
        return (minVal ... maxVal)
    }
    
    let IMAGE_PADDING: CGFloat = 50
    
    func thumbnails(geo: GeometryProxy) -> some View {
        ZStack {
            ForEach(imageRange, id: \.self) { index in
                imageView(index: index)
                    .offset(x: (currentOffset.width / currentScale + CGFloat(index-mediaEnv.activeMediaIndex) * (geo.size.width + IMAGE_PADDING)), y: currentOffset.height / currentScale)
                //          .scaleEffect(index == mediaEnv.activeMediaIndex ? currentScale : 1)
            }
        }
        .frame(width: geo.size.width)
        .scaleEffect(currentScale)
        .modifier(Self.ThumbnailGestures(fullscreenMode: fullscreenMode, touchStarted: $touchStarted, previousOffset: $previousOffset, currentOffset: $currentOffset, previousScale: $previousScale, currentScale: $currentScale))
    }
    
    var body: some View {
        GeometryReader { geo in
            thumbnails(geo: geo)
        }
        .aspectRatio(CGSize(width: mediaEnv.activeMedia?.thumbnail?.width ?? 3, height: mediaEnv.activeMedia?.thumbnail?.height ?? 2), contentMode: .fit)
    }
}

extension ThumbnailDetailsView {
    struct ThumbnailGestures: ViewModifier {
        let fullscreenMode: Bool
        @Binding var touchStarted: Bool
        @Binding var previousOffset: CGSize
        @Binding var currentOffset: CGSize
        @Binding var previousScale: CGFloat
        @Binding var currentScale: CGFloat
        @EnvironmentObject var mediaEnv: MediaEnvironment
        
        func body(content: Content) -> some View {
            content
                .gesture(
                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onChanged({ drag in
                            var newOffset = CGSize(width: drag.translation.width + previousOffset.width, height: previousOffset.height)
                            
                            if currentScale > 1 {
                                newOffset = CGSize(width: newOffset.width, height: newOffset.height + drag.translation.height)
                            }
                            
                            if touchStarted {
                                currentOffset = newOffset
                            } else {
                                touchStarted = true
                                withAnimation(Animation.spring(response: 0, dampingFraction: 1, blendDuration: 0)) {
                                    currentOffset = newOffset
                                }
                            }
                        })
                        .onEnded({ drag in
                            let SHIFT_THRESHOLD: CGFloat = 200
                            touchStarted = false
                            
                            let newOffset = CGSize(width: drag.translation.width + previousOffset.width, height: drag.translation.height + previousOffset.height)
                            
                            withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0)) {
                                if currentScale == 1 {
                                    currentOffset = CGSize(width: 0, height: 0)
                                } else {
                                    currentOffset = newOffset
                                }
                                
                                if (drag.predictedEndTranslation.width - SHIFT_THRESHOLD > 0 && mediaEnv.activeMediaIndex > 0) {
                                    mediaEnv.activeMediaIndex -= 1
                                }
                                if (drag.predictedEndTranslation.width + SHIFT_THRESHOLD < 0 && mediaEnv.activeMediaIndex + 1 < (mediaEnv.media?.count ?? 0)) {
                                    mediaEnv.activeMediaIndex += 1
                                }
                            }
                            
                            previousOffset = currentOffset
                        })
                )
                .onTapGesture {
                    mediaEnv.fullScreen = !fullscreenMode
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged({ newScale in
                            guard fullscreenMode else { return }
                            
                            currentScale = newScale * previousScale
                        })
                        .onEnded({ newScale in
                            guard fullscreenMode else { return }
                            
                            withAnimation(.interactiveSpring()) {
                                currentScale = max(1, newScale * previousScale)
                                previousScale = currentScale
                                
                                if currentScale == 1 {
                                    currentOffset = CGSize(width: 0, height: 0)
                                    previousOffset = currentOffset
                                }
                            }
                        })
                )
        }
    }
}
