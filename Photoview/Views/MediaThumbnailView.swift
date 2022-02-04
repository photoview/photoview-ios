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
    @State var showMediaDetailsSheet: Bool = false
    
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
//        let media = mediaEnv.media?[index]
        
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
        Button(action: {
            mediaEnv.activeMediaIndex = mediaIndex
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
