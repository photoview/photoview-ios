//
//  Apollo+Async.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 23/10/2021.
//

import Foundation
import Apollo

extension ApolloClient {
  func asyncFetch<Query: GraphQLQuery>(query: Query,
                                  cachePolicy: CachePolicy = .default,
                                  contextIdentifier: UUID? = nil,
                                  queue: DispatchQueue = .main
                                  ) async throws -> GraphQLResult<Query.Data> {
    try await withCheckedThrowingContinuation { continuation in
      self.fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue) { result in
        DispatchQueue.main.async {
          continuation.resume(with: result)
        }
      }
    }
  }
}
