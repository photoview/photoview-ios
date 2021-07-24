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
  
  @State var image: UIImage? = nil
  @State var task: URLSessionTask? = nil
  @State var canceled: Bool = false
  
  func fetchImage() {
    if image != nil { return }
    guard let url = url else { return }
    
    if let cachedImage = ProtectedImageCache.shared.cache.object(forKey: url as NSString) {
      print("Found in cache")
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
    
//    print("Fetching image \(request)")
    
    self.task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
//      print("Fetch complete")
      if !canceled, let error = error {
        fatalError("Error fetching protected image: \(error)")
      }
      
      if let data = data, let image = UIImage(data: data) {
        print("Saving to cache")
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
        Image(uiImage: image)
      } else {
        Rectangle().fill(Color(hue: 0, saturation: 0, brightness: 0.85))
      }
    }
    .onAppear {
      if image == nil {
        canceled = false
        self.fetchImage()
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
      .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
      .previewLayout(.sizeThatFits)
  }
}
