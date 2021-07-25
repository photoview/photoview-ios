//
//  MediaDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct MediaDetailsView: View {
  let mediaID: String
  
  @State var media: MediaDetailsQuery.Data.Medium? = nil
  
  init(mediaID: String, media: MediaDetailsQuery.Data.Medium? = nil) {
    self.mediaID = mediaID
    self.media = media
  }
  
  func fetchMediaDetails() {
    Network.shared.apollo?.fetch(query: MediaDetailsQuery(mediaID: mediaID)) { data in
      switch data {
      case .success(let data):
        DispatchQueue.main.async {
          self.media = data.data?.media
        }
      case .failure(let error):
        fatalError("Error fetching media details: \(error)")
      }
    }
  }
  
  var header: some View {
    VStack {
      ProtectedImageView(url: media?.thumbnail?.url) { uiImg in
        AnyView(
          Image(uiImage: uiImg)
            .resizable()
            .scaledToFit()
        )
      }
      .aspectRatio(CGSize(width: media?.thumbnail?.width ?? 3, height: media?.thumbnail?.height ?? 2), contentMode: .fit)
      .padding(.horizontal, -16)
      .padding(.top, -6)
      
      Text(media?.title ?? "Loading media...")
        .font(.headline)
        .padding(.horizontal)
      
      if let exif = media?.exif {
        ExifDetailsView(exif: exif)
          .padding(.top)
      }
    }
    .foregroundColor(.primary)
  }
  
  var body: some View {
    List {
      Section(header: header) {
        EmptyView()
      }
      DownloadDetailsView(downloads: media?.downloads ?? [])
      ShareDetailsView()
    }
    .listStyle(InsetGroupedListStyle())
    .redacted(reason: media == nil ? .placeholder : [])
    .onAppear {
      fetchMediaDetails()
    }
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
  
  static var previews: some View {
    MediaDetailsView(mediaID: "", media: sampleMedia)
  }
}
