//
//  FullScreenMediaGalleryView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI
import Apollo

struct FullScreenMediaGalleryView: View {
    
    @EnvironmentObject var mediaEnv: MediaEnvironment
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    @Binding var showMedia: Bool

    @State var mediaDetails: MediaDetailsQuery.Data.Medium? = nil
    
    @State private var isShowingNavbarMenu = true
    @State private var isZoomed = false
    @State var isLoading = false
    @State var isVideo = false
    
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
    
    var mediaInformationView: some View {
        VStack {
            List {
                if let exif = mediaDetails?.exif {
                    ExifDetailsView(exif: exif)
                        .listRowBackground(Color.clear)
                }
                DownloadDetailsView(downloads: (mediaDetails?.downloads ?? []).sorted { $0.mediaUrl.fileSize > $1.mediaUrl.fileSize })
                if let activeMedia = mediaEnv.activeMedia {
                    ShareDetailsView(mediaID: activeMedia.id, shares: mediaDetails?.shares ?? [], refreshMediaDetails: { fetchMediaDetails() })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .redacted(reason: mediaDetails == nil ? .placeholder : [])
            Spacer()
            Text(mediaDetails?.title ?? "").font(.footnote)
        }
        .navigationBarTitle("Details", displayMode: .inline)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .opacity(isShowingNavbarMenu ? 0.0 : 1.0)
                    MediaGalleryView(mediaDetails: mediaDetails, isLoading: $isLoading, isVideo: $isVideo)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onTapGesture {
                    // Disable the onTap gesture if it's a video so they can tap to play the video
                    if !isVideo {
                        withAnimation(.easeIn(duration: 0.35)) {
                            isShowingNavbarMenu.toggle()
                        }
                    }
                    else {
                        isShowingNavbarMenu = true
                    }
                }
                VStack(spacing: 0) {
                    // Always show the nav bar if it's a video
                    // Do not want to conflict "hide navbar" tap with a "play video" tap
                    if isShowingNavbarMenu || isVideo {
                        ZStack {
                            HStack {
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                }
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Group {
                                    // Info button
                                    NavigationLink(destination: mediaInformationView) {
                                        Image(systemName: "info.circle")
                                            .imageScale(.large) // Icon size
                                            .padding(.trailing, 5)
                                    }

                                    // Close button
                                    Button(action: {
                                        showMedia = false
                                        isLoading = false
                                    }) {
                                        Image(systemName: "xmark")
                                            .imageScale(.large) // Icon size
                                            .padding(.trailing, 5)
                                    }
                                    .padding()
                                }
                            }
                        }
                        .background(BlurBackgroundVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .ignoresSafeArea())
                        Spacer() // Pushes the bar to the top of the screen
                    }
                }
            }
            .hideDefaultNavigationBar()
        }
        .onAppear {
            fetchMediaDetails()
        }
        .onChange(of: mediaEnv.activeMediaIndex, perform: { value in
            fetchMediaDetails()
        })
        .statusBarHidden(!isShowingNavbarMenu)
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
        FullScreenMediaGalleryView(mediaEnv: EnvironmentObject<MediaEnvironment>(), showMedia: .constant(true), mediaDetails: nil)
//            .environmentObject(mediaEnvironment)
    }
}

// Blurred Background
struct BlurBackgroundVisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
