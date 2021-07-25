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
  
  let cache: NSCache<NSString, UIImage> = NSCache()
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
    
    if let cachedImage = ProtectedImageCache.shared.cache.object(forKey: url as NSString) {
      image = cachedImage
      return
    }
    
    let keychain = KeychainSwift()
    guard let token = keychain.get("access-token") else {
      fatalError("Token missing")
    }
    
    guard let instanceStr = keychain.get("server-instance"), let instanceURL = URL(string: instanceStr) else {
      fatalError("Invalid instance")
    }
    
    guard let imgURL = URL(string: url, relativeTo: instanceURL) else {
      fatalError("Invalid url")
    }
    
    var request = URLRequest(url: imgURL)
    request.addValue("auth-token=\(token)", forHTTPHeaderField: "Cookie")
    
    self.task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
      if !canceled, let error = error {
        fatalError("Error fetching protected image: \(error)")
      }
      
      if let data = data, let image = UIImage(data: data) {
        ProtectedImageCache.shared.cache.setObject(image, forKey: url as NSString)
        DispatchQueue.main.async {
          self.image = image
        }
      }
    }
    
    self.task?.resume()
  }
  
  var body: some View {
    Group {
      if let image = image {
        imageView(image)
      } else {
        Rectangle()
          .fill(Color(hue: 0, saturation: 0, brightness: 0.85))
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
