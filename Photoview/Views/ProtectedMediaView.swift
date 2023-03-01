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
    typealias Download = MediaDetailsQuery.Data.Medium.Download
    
    @Binding private var isVideo: Bool
    
    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy = CGFloat(1.0)
    
    @Binding private var isLoading: Bool
    
    @State private var showVideo: Bool = false
    
    private var geo: GeometryProxy

    /// Show the fully loaded media view
    init(mediaDetails: MediaDetailsQuery.Data.Medium, isLoading: Binding<Bool>, isVideo: Binding<Bool>, geo: GeometryProxy) {
        self.mediaDetails = mediaDetails
        self.mediaItem = mediaDetails.fragments.mediaItem
        self._isLoading = isLoading
        self._isVideo = isVideo
        self.geo = geo
    }
    
    /// Show a thumbnail like media view with less information
    init(mediaItem: MediaItem, isVideo: Binding<Bool>, geo: GeometryProxy) {
        self.mediaDetails = nil
        self.mediaItem = mediaItem
        self._isLoading = .constant(false)
        self._isVideo = isVideo
        self.geo = geo
    }
    
    var imageView: ProtectedImageView {
        let downloads: [Download] = (mediaDetails?.downloads ?? []).sorted { $0.mediaUrl.fileSize > $1.mediaUrl.fileSize }
        self.isVideo = false
        let url = (downloads.count > 0 ? downloads[0].mediaUrl.url : self.mediaItem.thumbnail?.url)
  
        return ProtectedImageView(url: url, isLoading: $isLoading, blurhash: self.mediaItem.blurhash) { image in
            return AnyView(
                SwiftUIZoomableImageViewer(image: Image(uiImage: image))
            )
        }
    }
    
    func videoView(mediaDetails: MediaDetailsQuery.Data.Medium) -> some View {
        self.isVideo = true
        let media = mediaDetails.fragments.mediaItem
        return GeometryReader { geo in
            ZStack {
                Button(action: {
                    self.showVideo = true
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: min(geo.size.height, geo.size.width) / 5, height: min(geo.size.height, geo.size.width) / 5, alignment: .center)
                                .foregroundColor(.white)
                                .opacity(0.8)
                            Spacer()
                        }
                    }
                }
                .zIndex(1)
                ProtectedImageView(url: media.thumbnail?.url, isLoading: nil, blurhash: media.blurhash) { image in
                    AnyView(
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                    )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .fullScreenCover(isPresented: $showVideo) {
                ProtectedVideoView(url: mediaDetails.videoWeb?.url, isLoading: $isLoading)
                    .ignoresSafeArea()
        }
    }
    
    func detailedView(mediaDetails: MediaDetailsQuery.Data.Medium) -> AnyView {
        switch self.mediaItem.type {
        case .photo:
            return AnyView(imageView)
        case .video:
            return AnyView(videoView(mediaDetails: mediaDetails).ignoresSafeArea())
        case .__unknown(let raw):
            fatalError("Unknown media type: \(raw)")
        }
    }
    
    var body: some View {
        if let mediaDetails = mediaDetails {
            return detailedView(mediaDetails: mediaDetails)
        } else {
            return AnyView(imageView)
        }
    }
}
