//
//  ProtectedImageView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import KeychainSwift

protocol ProtectedCache {
    associatedtype CacheData: AnyObject
    var cache: NSCache<NSString, CacheData> { get }
    func parseData(_ data: Data) -> CacheData?
}

extension ProtectedCache {
    
    func fetch(url: String, callback: @escaping (_ data: CacheData) -> Void) -> URLSessionTask? {
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
            
            if let data = data, let cacheData = self.parseData(data) {
                self.cache.setObject(cacheData, forKey: url as NSString)
                DispatchQueue.main.async {
                    callback(cacheData)
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

class ProtectedImageCache: ProtectedCache {
    static let shared: ProtectedImageCache = ProtectedImageCache()
    
    internal let cache: NSCache<NSString, UIImage> = NSCache()
    
    func parseData(_ data: Data) -> UIImage? {
        UIImage(data: data)
    }
}

/// Shows a media thumbnail, used in grids where a lot of media is shown at once
struct ProtectedImageView: View {
    
    let url: String?
    let blurhash: String?
    let imageView: (_ image: UIImage) -> AnyView
    
    init(url: String?, blurhash: String? = nil, imageView: @escaping (_ image: UIImage) -> AnyView) {
        self.url = url
        self.blurhash = blurhash
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
    @State var imageLoaded: Bool = false
    
    var presentImage: UIImage? {
        if self.image != nil {
            return self.image
        }
        
        if let blurhash = self.blurhash {
            return UIImage(blurHash: blurhash, size: CGSize(width: 4, height: 3))
        }
        
        return nil
    }
    
    func fetchImage(url: String) {
        self.task = ProtectedImageCache.shared.fetch(url: url) { image in
            self.image = image
        }
    }
    
    var body: some View {
        Group {
            if let image = self.presentImage {
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
