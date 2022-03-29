//
//  MediaThumbnailView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct MediaThumbnailView: View {
    let media: MediaItem
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    @State var showMediaDetails: Bool = false
    
    var onMediaSelected: (() -> Void)? = nil
    
    var mediaIndex: Int {
        return mediaEnv.mediaIndex(media)
    }
    
    var videoPlayIcon: some View {
        Image(systemName: "play.fill")
            .resizable()
            .frame(width: 32, height: 32, alignment: .center)
            .foregroundColor(.white)
            .opacity(0.8)
    }
    
    var thumbnailView: some View {
        return ZStack(alignment: .center) {
            GeometryReader { geo in
                    ProtectedImageView(url: media.thumbnail?.url, blurhash: media.blurhash) { image in
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
            
            if media.type == .video {
                videoPlayIcon
            }
        }
    }
    
    var body: some View {
        if UIDevice.isLargeScreen {
            Button(action: {
                mediaEnv.activeMediaIndex = mediaIndex
                onMediaSelected?()
            }) {
                thumbnailView
            }
        } else {
            NavigationLink(isActive: $showMediaDetails, destination: {
                MediaDetailsView(mediaEnv: mediaEnv)
            }) {
                thumbnailView
            }
            .onChange(of: showMediaDetails) { show in
                if show {
                    mediaEnv.activeMediaIndex = mediaIndex
                }
            }
        }
    }
}
