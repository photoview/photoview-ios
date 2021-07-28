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
  @State var downloadTask: (URLSessionDataTask, Download)? = nil
  
  @State var sharePresented: Bool = false
  @State var shareData: Data? = nil
  
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
  
  func filetypeFormatted(download: Download) -> String {
    return URL(string: download.mediaUrl.url)!.pathExtension
  }
  
  func downloadAction(download: Download) {
    if let downloadTask = downloadTask {
      if downloadTask.1.mediaUrl.url == download.mediaUrl.url {
        return
      } else {
        downloadTask.0.cancel()
        self.downloadTask = nil
      }
    }
    
    let request = Network.shared.protectedURLRequest(url: download.mediaUrl.url)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error downloading image: \(error)")
        return
      }
      
      DispatchQueue.main.async {
        downloadTask = nil
        if let data = data {
          shareData = data
          sharePresented = true
        }
      }
    }
    
    task.resume()
    downloadTask = (task, download)
  }
  
  func downloadLoading(_ download: Download) -> Bool {
    var loading = false
    if let downloadTask = downloadTask {
      loading = downloadTask.1.mediaUrl.url == download.mediaUrl.url && downloadTask.0.state == .running
    }
    
    return loading
  }
  
  var body: some View {
    Section(header: Text("Download")) {
      ForEach(downloads, id: \.title) { dl in
        Button(action: {
          downloadAction(download: dl)
        }, label: {
          HStack(spacing: 10) {
            if downloadLoading(dl) {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            }
            Text(dl.title)
            Spacer()
            HStack {
              Text("\(ByteCountFormatter().string(fromByteCount: Int64(dl.mediaUrl.fileSize)))").font(.caption)
              Text(filetypeFormatted(download: dl)).font(.caption)
              Text(dimensionsFormatted(download: dl)).font(.caption)
            }
          }
          .foregroundColor(.primary)
        })
        .sheet(isPresented: $sharePresented, content: {
          ShareSheet(activityItems: [shareData!])
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
