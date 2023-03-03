//
//  ProtectedCache.swift
//  Photoview
//
//  Created by Dhrumil Shah on 2/24/23.
//

import Foundation
import SwiftUI

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
    internal var count = 0
    static let shared: ProtectedImageCache = ProtectedImageCache()
    
    internal let cache: NSCache<NSString, UIImage> = NSCache()
    
    func parseData(_ data: Data) -> UIImage? {
        UIImage(data: data)
    }
}
