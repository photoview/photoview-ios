//
//  ProtectedImageView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import KeychainSwift

class ProtectedImageCache {
  static let shared: ProtectedImageCache = ProtectedImageCache()
  
  private let cache: NSCache<NSString, UIImage> = NSCache()
  
  func fetchImage(url: String, callback: @escaping (_ image: UIImage) -> Void) -> URLSessionTask? {
    if let cachedImage = self.cache.object(forKey: url as NSString) {
      callback(cachedImage)
      return nil
    }
    
    let request = Network.shared.protectedURLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        if error.localizedDescription != "cancelled" {
          print("Error fetching protected image: \(error)")
        }
        return
      }
      
      if let data = data, let image = UIImage(data: data) {
        ProtectedImageCache.shared.cache.setObject(image, forKey: url as NSString)
        DispatchQueue.main.async {
          callback(image)
        }
      }
    }
    
    task.resume()
    
    return task
  }
  
  func clearCache() {
    cache.removeAllObjects()
  }
  
}

struct ProtectedImageView: View {

  let url: String?
  let imageView: (_ image: UIImage) -> AnyView
  
  init(url: String?, imageView: @escaping (_ image: UIImage) -> AnyView) {
    self.url = url
    self.imageView = imageView
  }
  
  init(url: String?) {
    self.init(url: url) { img in
      AnyView(Image(uiImage: img))
    }
  }
  
  @State var image: UIImage? = nil
  @State var task: URLSessionTask? = nil
  @State var canceled: Bool = false
  
  func fetchImage(url: String) {
    if image != nil { return }
    
    self.task = ProtectedImageCache.shared.fetchImage(url: url) { image in
      self.image = image
    }
  }
  
  var body: some View {
    Group {
      if let image = image {
        imageView(image)
      } else {
        Rectangle()
          .fill(Color("PlaceholderBackground"))
      }
    }
    .onChange(of: url) { newURL in
      if let newURL = newURL {
        self.fetchImage(url: newURL)
      } else {
        self.image = nil
      }
    }
    .onAppear {
      if image == nil, let url = url {
        canceled = false
        self.fetchImage(url: url)
      }
    }
    .onDisappear {
      canceled = true
      self.task?.cancel()
    }
  }
}

struct ProtectedImageView_Previews: PreviewProvider {
  static var previews: some View {
    ProtectedImageView(url: nil)
      .frame(width: 100, height: 100)
      .previewLayout(.sizeThatFits)
  }
}
