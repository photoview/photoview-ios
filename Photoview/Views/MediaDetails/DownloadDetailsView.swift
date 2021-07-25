//
//  DownloadDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct DownloadDetailsView: View {
  typealias Download = MediaDetailsQuery.Data.Medium.Download
  
  let downloads: [Download]
  @State var sharePresented: Bool = false
  
  static var dimensionsFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.none
    return formatter
  }
  
  func dimensionsFormatted(download: Download) -> String {
    let width = Self.dimensionsFormatter.string(from: NSNumber(value: download.mediaUrl.width)) ?? "ERROR"
    let height = Self.dimensionsFormatter.string(from: NSNumber(value: download.mediaUrl.height)) ?? "ERROR"
    
    return "\(width) x \(height)"
  }
  
  func downloadAction(download: Download) {
    sharePresented = true
  }
  
  var body: some View {
    Section(header: Text("Download")) {
      ForEach(downloads, id: \.title) { dl in
        Button(action: {
          downloadAction(download: dl)
        }, label: {
          HStack(spacing: 10) {
            Text(dl.title)
            Spacer()
            Text("\(ByteCountFormatter().string(fromByteCount: Int64(dl.mediaUrl.fileSize)))").font(.caption)
            HStack {
              Spacer()
              Text(dimensionsFormatted(download: dl)).font(.caption)
            }.frame(width: 90)
          }
          .foregroundColor(.primary)
        })
//        .buttonStyle()
        .sheet(isPresented: $sharePresented, content: {
          ShareSheet(activityItems: ["This app is my favorite"])
        })
      }
    }
  }
}

struct DownloadDetailsView_Previews: PreviewProvider {
  
  static var downloadsSample = [
    MediaDetailsQuery.Data.Medium.Download(title: "Original", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 2048, height: 1536, fileSize: 20000)),
    MediaDetailsQuery.Data.Medium.Download(title: "High-res", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1024, height: 768, fileSize: 20000)),
    MediaDetailsQuery.Data.Medium.Download(title: "Thumbnail", mediaUrl: MediaDetailsQuery.Data.Medium.Download.MediaUrl(url: "link", width: 1080, height: 720, fileSize: 20000))
  ]
  
  static var previews: some View {
    List {
      DownloadDetailsView(downloads: downloadsSample)
    }.listStyle(InsetGroupedListStyle())
  }
}
