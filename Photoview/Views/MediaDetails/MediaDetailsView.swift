//
//  MediaDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI
import Apollo

struct MediaDetailsView: View {
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    
    @State var mediaDetails: MediaDetailsQuery.Data.Medium? = nil
    
    func fetchMediaDetails() {
        guard let activeMedia = mediaEnv.activeMedia else { return }
        
        Network.shared.apollo?.fetch(query: MediaDetailsQuery(mediaID: activeMedia.id), cachePolicy: .returnCacheDataAndFetch) { data in
            switch data {
            case .success(let data):
                DispatchQueue.main.async {
                    self.mediaDetails = data.data?.media
                    if let thumbnail = self.mediaDetails?.fragments.mediaItem.thumbnail {
                        mediaEnv.media?[mediaEnv.activeMediaIndex].thumbnail = thumbnail
                    }
                }
            case .failure(let error):
                Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch media details", error: error), showWelcomeScreen: showWelcome)
            }
        }
    }
    
    var header: some View {
        VStack {
            ThumbnailDetailsView(mediaDetails: mediaDetails, fullscreenMode: false)
            
            Text(mediaDetails?.title ?? "Loading media...")
                .font(.headline)
                .padding(.horizontal)
            
            if let exif = mediaDetails?.exif {
                ExifDetailsView(exif: exif)
                    .padding(.top)
            }
        }
        .foregroundColor(.primary)
        .textCase(.none)
        .padding(0)
    }
    
    var body: some View {
        List {
            Section(header: header) {
                EmptyView()
            }
            DownloadDetailsView(downloads: (mediaDetails?.downloads ?? []).sorted { $0.mediaUrl.fileSize > $1.mediaUrl.fileSize })
            if let activeMedia = mediaEnv.activeMedia {
                ShareDetailsView(mediaID: activeMedia.id, shares: mediaDetails?.shares ?? [], refreshMediaDetails: { fetchMediaDetails() })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .redacted(reason: mediaDetails == nil ? .placeholder : [])
        .onAppear {
            fetchMediaDetails()
        }
        .onChange(of: mediaEnv.activeMediaIndex, perform: { value in
            fetchMediaDetails()
        })
        .fullScreenCover(isPresented: $mediaEnv.fullScreen, content: {
            FullScreenGalleryView(mediaDetails: mediaDetails)
            // can crash without this
                .environmentObject(mediaEnv)
        })
    }
}

struct MediaDetailsView_Previews: PreviewProvider {

//    static let sampleMedia = MediaDetailsQuery.Data.Medium(
//        id: "123",
//        title: "Media title",
//        thumbnail: nil,
//        exif: MediaDetailsQuery.Data.Medium.Exif(
//            camera: "Camera",
//            maker: "Model 3000",
//            lens: "300 mm",
//            dateShot: Time(date: Date()),
//            exposure: 0.01,
//            aperture: 2.4,
//            iso: 100,
//            focalLength: 35,
//            flash: 0,
//            exposureProgram: 1),
//        type: .photo, shares: [], downloads: [
//            MediaDetailsQuery.Data.Medium.Download(title: "Original", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000)),
//            MediaDetailsQuery.Data.Medium.Download(title: "High-res", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000)),
//            MediaDetailsQuery.Data.Medium.Download(title: "Thumbnail", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000))
//        ])
//
//    static let mediaEnvironment = MediaEnvironment(
//        media: [MediaEnvironment.Media(id: "123", thumbnail: nil, favorite: false)],
//        activeMediaIndex: 0
//    )

    static var previews: some View {
        MediaDetailsView(mediaEnv: EnvironmentObject<MediaEnvironment>(), mediaDetails: nil)
//            .environmentObject(mediaEnvironment)
    }
}
