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
  
  var body: some View {
    VStack {
      ProtectedImageView(url: media?.thumbnail?.url) { uiImg in
        AnyView(
          Image(uiImage: uiImg)
            .resizable()
            .scaledToFit()
        )
      }
      .aspectRatio(CGSize(width: media?.thumbnail?.width ?? 3, height: media?.thumbnail?.height ?? 2), contentMode: .fit)
      Text(media?.title ?? "Loading media...")
        .font(.headline)
      if let exif = media?.exif {
        ExifDetailsView(exif: exif)
          .padding(.top)
      }
      Spacer()
    }
    .redacted(reason: media == nil ? .placeholder : [])
    .onAppear {
      fetchMediaDetails()
    }
  }
}

struct MediaDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    MediaDetailsView(mediaID: "")
  }
}
