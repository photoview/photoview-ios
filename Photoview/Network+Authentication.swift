//
//  Network+Authentication.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import Foundation
import Apollo
import KeychainSwift

extension Network {
  enum AuthResult {
    case success
    case failure(message: String)
  }
  
  func authorize(credentials: CredentialsModel, onComplete: @escaping (_ result: AuthResult) -> Void) {
    guard var url = URL(string: credentials.instance) else {
      onComplete(.failure(message: "Invalid instance URL"))
      return
    }
    
    url.appendPathComponent("graphql")
    
    // Store new client
    let client = ApolloClient(url: url)
    self.apollo = client
    
    client.perform(mutation: AuthorizeUserMutation(username: credentials.username, password: credentials.password)) { result in
      switch result {
      case .success(let data):
        if let authUser = data.data?.authorizeUser {
          if authUser.success, let token = authUser.token {
            self.persistCredentials(instance: url, token: token)
            onComplete(.success)
          } else {
            onComplete(.failure(message: authUser.status))
          }
        } else {
          onComplete(.failure(message: "No data returned from server"))
        }
      case .failure(let error):
        onComplete(.failure(message: error.localizedDescription))
      }
    }
  }
  
  private func persistCredentials(instance: URL, token: String) {
    let keychain = KeychainSwift()
    keychain.set(token, forKey: "access-token")
    keychain.set(instance.absoluteString, forKey: "server-instance")
    
    if loadCredentials() == false {
      fatalError("loadCredentials returned false after persisting credentials")
    }
  }
  
  func loadCredentials() -> Bool {
    let keychain = KeychainSwift()
    if let token = keychain.get("access-token"),
       let instance = keychain.get("server-instance"),
       let url = URL(string: instance) {
      
      let headers = ["Cookie": "auth-token=\(token)"]
      
      let store = ApolloStore(cache: InMemoryNormalizedCache())
      let provider = DefaultInterceptorProvider(store: store)
      let transport = RequestChainNetworkTransport(
        interceptorProvider: provider, endpointURL: url, additionalHeaders: headers)
      
      self.apollo = ApolloClient(networkTransport: transport, store: store)
      return true
    }
    
    return false
  }
  
  func clearCredentials() {
    let keychain = KeychainSwift()
    
    keychain.delete("access-token")
    keychain.delete("server-instance")
    self.apollo?.clearCache()
    ProtectedImageCache.shared.clearCache()
  }
}
