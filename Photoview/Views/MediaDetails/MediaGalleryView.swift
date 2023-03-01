//
//  MediaGalleryView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct MediaGalleryView: View {
    
    let mediaDetails: MediaDetailsQuery.Data.Medium?
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    
    @Binding var isLoading: Bool;
    
    @State var touchStarted: Bool = false
    @State var currentOffset: CGSize = CGSize(width: 0, height: 0)
    @State var previousOffset: CGSize = CGSize(width: 0, height: 0)
    @State var currentScale: CGFloat = 1
    @State var previousScale: CGFloat = 1
    
    @State var currentImageScrollIndex = 0
    @State private var loadedTabs = Set<Int>([0])
    
    @State var totalNumberOfImages: ClosedRange<Int> = 0 ... 0
    @State private var imageRange: ClosedRange<Int> = 0 ... 1
    
    @Binding var isVideo: Bool
    
    func imageView(index: Int, geo: GeometryProxy) -> some View {
        if (mediaEnv.activeMediaIndex == index) {
            let media = mediaEnv.media![index]
            
            if let mediaDetails = mediaDetails, index == mediaEnv.activeMediaIndex, media.id == mediaDetails.id {
                return AnyView(ProtectedMediaView(mediaDetails: mediaDetails, isLoading: $isLoading, isVideo: $isVideo, geo: geo))
            } else {
                return AnyView(ProtectedMediaView(mediaItem: media, isVideo: $isVideo, geo: geo))
            }
        }
        else {
            return AnyView(ProgressView())
        }
    }
    
    func imagePreloadRangeCalc() -> ClosedRange<Int> {
        guard let media = mediaEnv.media else { return mediaEnv.activeMediaIndex ... mediaEnv.activeMediaIndex }
        
        currentImageScrollIndex = mediaEnv.activeMediaIndex
        
        let minVal = max(mediaEnv.activeMediaIndex - 2, 0)
        let maxVal = min(mediaEnv.activeMediaIndex + 2, media.count - 1)
        
        // TODO: Could be removed
        totalNumberOfImages = (0 ... media.count - 1)

        return (minVal ... maxVal)
    }
    
    let IMAGE_PADDING: CGFloat = 50
    
    var body: some View {
        GeometryReader { geo in
            TabView(selection: $currentImageScrollIndex) {
                ForEach(totalNumberOfImages, id: \.self) { index in
                    imageView(index: index, geo: geo)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: currentImageScrollIndex) { newValue in
                mediaEnv.activeMediaIndex = newValue
                imageRange = imagePreloadRangeCalc()
            }
        }
        .onAppear() {
            imageRange = imagePreloadRangeCalc()
        }
    }
}

//extension MediaGalleryView {
//    struct ThumbnailGestures: ViewModifier {
//        let fullscreenMode: Bool
//        @Binding var touchStarted: Bool
//        @Binding var previousOffset: CGSize
//        @Binding var currentOffset: CGSize
//        @Binding var previousScale: CGFloat
//        @Binding var currentScale: CGFloat
//        @EnvironmentObject var mediaEnv: MediaEnvironment
//
//        func body(content: Content) -> some View {
//            content
//                .gesture(
//                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
//                        .onChanged({ drag in
//                            var newOffset = CGSize(width: drag.translation.width + previousOffset.width, height: previousOffset.height)
//
//                            if currentScale > 1 {
//                                newOffset = CGSize(width: newOffset.width, height: newOffset.height + drag.translation.height)
//                            }
//
//                            if touchStarted {
//                                currentOffset = newOffset
//                            } else {
//                                touchStarted = true
//                                withAnimation(Animation.spring(response: 0, dampingFraction: 1, blendDuration: 0)) {
//                                    currentOffset = newOffset
//                                }
//                            }
//                        })
//                        .onEnded({ drag in
//                            let SHIFT_THRESHOLD: CGFloat = 200
//                            touchStarted = false
//
//                            let newOffset = CGSize(width: drag.translation.width + previousOffset.width, height: drag.translation.height + previousOffset.height)
//
//                            withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0)) {
//                                if currentScale == 1 {
//                                    currentOffset = CGSize(width: 0, height: 0)
//                                } else {
//                                    currentOffset = newOffset
//                                }
//
//                                if (drag.predictedEndTranslation.width - SHIFT_THRESHOLD > 0 && mediaEnv.activeMediaIndex > 0) {
//                                    mediaEnv.activeMediaIndex -= 1
//                                }
//                                if (drag.predictedEndTranslation.width + SHIFT_THRESHOLD < 0 && mediaEnv.activeMediaIndex + 1 < (mediaEnv.media?.count ?? 0)) {
//                                    mediaEnv.activeMediaIndex += 1
//                                }
//                            }
//
//                            previousOffset = currentOffset
//                        })
//                )
//                .gesture(
//                    MagnificationGesture()
//                        .onChanged({ newScale in
//                            guard fullscreenMode else { return }
//
//                            currentScale = newScale * previousScale
//                        })
//                        .onEnded({ newScale in
//                            guard fullscreenMode else { return }
//
//                            withAnimation(.interactiveSpring()) {
//                                currentScale = max(1, newScale * previousScale)
//                                previousScale = currentScale
//
//                                if currentScale == 1 {
//                                    currentOffset = CGSize(width: 0, height: 0)
//                                    previousOffset = currentOffset
//                                }
//                            }
//                        })
//                )
//        }
//    }
//}
