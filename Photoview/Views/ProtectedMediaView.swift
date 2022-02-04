//
//  ProtectedMediaView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 04/02/2022.
//

import SwiftUI

struct ProtectedMediaView: View {
    let mediaDetails: MediaDetailsQuery.Data.Medium?
    let mediaItem: MediaItem
    
    /// Show the fully loaded media view
    init(mediaDetails: MediaDetailsQuery.Data.Medium) {
        self.mediaDetails = mediaDetails
        self.mediaItem = mediaDetails.fragments.mediaItem
    }
    
    /// Show a thumbnail like media view with less information
    init(mediaItem: MediaItem) {
        self.mediaDetails = nil
        self.mediaItem = mediaItem
    }
    
    var imageView: AnyView {
        AnyView(
            ProtectedImageView(url: self.mediaItem.thumbnail?.url, blurhash: self.mediaItem.blurhash) { image in
                AnyView(
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                )
            }
        )
    }
    
    func videoView(mediaDetails: MediaDetailsQuery.Data.Medium) -> AnyView {
        AnyView(
            ProtectedVideoView(url: mediaDetails.videoWeb?.url)
        )
    }
    
    func detailedView(mediaDetails: MediaDetailsQuery.Data.Medium) -> AnyView {
        switch self.mediaItem.type {
        case .photo:
            return imageView
        case .video:
            return videoView(mediaDetails: mediaDetails)
        case .__unknown(let raw):
            fatalError("Unknown media type: \(raw)")
        }
    }
    
    var body: some View {
        if let mediaDetails = mediaDetails {
            return detailedView(mediaDetails: mediaDetails)
        } else {
            return imageView
        }
    }
}
