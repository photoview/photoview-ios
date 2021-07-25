//
//  MediaDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct MediaDetailsView: View {
  
  @EnvironmentObject var mediaEnv: MediaEnvironment
  @State var mediaDetails: MediaDetailsQuery.Data.Medium? = nil
  
  func fetchMediaDetails() {
    guard let activeMedia = mediaEnv.activeMedia else { return }
    
    Network.shared.apollo?.fetch(query: MediaDetailsQuery(mediaID: activeMedia.id)) { data in
      switch data {
      case .success(let data):
        DispatchQueue.main.async {
          self.mediaDetails = data.data?.media
        }
      case .failure(let error):
        fatalError("Error fetching media details: \(error)")
      }
    }
  }
  
  var header: some View {
    VStack {
      ThumbnailDetailsView()
      
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
  }
  
  var body: some View {
    List {
      Section(header: header) {
        EmptyView()
      }
      DownloadDetailsView(downloads: mediaDetails?.downloads ?? [])
      ShareDetailsView()
    }
    .listStyle(InsetGroupedListStyle())
    .redacted(reason: mediaDetails == nil ? .placeholder : [])
    .onAppear {
      fetchMediaDetails()
    }
    .onChange(of: mediaEnv.activeMediaIndex, perform: { value in
      fetchMediaDetails()
    })
  }
}

struct MediaDetailsView_Previews: PreviewProvider {

  static let sampleMedia = MediaDetailsQuery.Data.Medium(
    id: "123",
    title: "Media title",
    thumbnail: nil,
    exif: MediaDetailsQuery.Data.Medium.Exif(
      camera: "Camera",
      maker: "Model 3000",
      lens: "300 mm",
      dateShot: "01/01/2001",
      exposure: 0.01,
      aperture: 2.4,
      iso: 100,
      focalLength: 35,
      flash: 0,
      exposureProgram: 1),
    type: .photo, shares: [], downloads: [
      MediaDetailsQuery.Data.Medium.Download(title: "Original", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000)),
      MediaDetailsQuery.Data.Medium.Download(title: "High-res", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000)),
      MediaDetailsQuery.Data.Medium.Download(title: "Thumbnail", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000))
    ])
  
  static let mediaEnvironment = MediaEnvironment(
    album: AlbumViewSingleAlbumQuery.Data.Album(
      id: "123",
      title: "Sample album",
      media: [AlbumViewSingleAlbumQuery.Data.Album.Medium(id: "123", thumbnail: nil, favorite: false)],
      subAlbums: []),
      activeMediaIndex: 0
  )

  static var previews: some View {
    MediaDetailsView(mediaEnv: EnvironmentObject<MediaEnvironment>(), mediaDetails: sampleMedia)
      .environmentObject(mediaEnvironment)
  }
}
