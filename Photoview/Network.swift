//
//  Network.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import Foundation
import SwiftUI
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
    
    func authTokenCookieValue() -> String {
        let keychain = KeychainSwift()
        guard let token = keychain.get("access-token") else {
            fatalError("Token missing")
        }
        
        return "auth-token=\(token)"
    }
    
    func fullUrl(_ url: String) -> URL {
        let keychain = KeychainSwift()
        
        guard let instanceStr = keychain.get("server-instance"), let instanceURL = URL(string: instanceStr) else {
            fatalError("Invalid instance")
        }
        
        guard let fullURL = URL(string: url, relativeTo: instanceURL) else {
            fatalError("Invalid url")
        }
        
        return fullURL
    }
    
    func protectedURLRequest(url: String) -> URLRequest {
        var request = URLRequest(url: self.fullUrl(url))
        request.addValue(self.authTokenCookieValue(), forHTTPHeaderField: "Cookie")
        
        return request
    }
    
    func handleGraphqlError(error: NetworkError, showWelcomeScreen: ShowWelcomeScreen) {
        self.clearCredentials()
        showWelcomeScreen.isPresented = true
    }
}

struct NetworkError: Error {
    let message: String
    let error: Error?
}
