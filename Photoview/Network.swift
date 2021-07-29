//
//  Network.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import Foundation
import Apollo
import KeychainSwift

class Network {
  static let shared = Network()
  var apollo: ApolloClient?
  
  var serverInstanceURL: URL? {
    guard let instance = KeychainSwift().get("server-instance") else { return nil }
    guard let url = URL(string: instance) else { return nil }
    
    return url
  }
  
  func protectedURLRequest(url: String) -> URLRequest {
    let keychain = KeychainSwift()
    guard let token = keychain.get("access-token") else {
      fatalError("Token missing")
    }
    
    guard let instanceStr = keychain.get("server-instance"), let instanceURL = URL(string: instanceStr) else {
      fatalError("Invalid instance")
    }
    
    guard let fullURL = URL(string: url, relativeTo: instanceURL) else {
      fatalError("Invalid url")
    }
    
    var request = URLRequest(url: fullURL)
    request.addValue("auth-token=\(token)", forHTTPHeaderField: "Cookie")
    
    return request
  }
  
}
