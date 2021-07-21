//
//  Network.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
  var apollo: ApolloClient?
}
