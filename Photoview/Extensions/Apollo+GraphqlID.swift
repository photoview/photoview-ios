//
//  Apollo+GraphqlID.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import Foundation
import Apollo

extension GraphQLID {
  init(_ id: Int) {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    
    self = formatter.string(from: id as NSNumber)!
  }
}
