//
//  MediaSearch.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 18/02/2022.
//

import SwiftUI

struct SearchResultsOverlay: View {
    
    typealias SearchQueryData = MediaSearchQuery.Data.Search
    
    @Binding var searchText: String
    @Environment(\.isSearching) private var isSearching: Bool
    @EnvironmentObject private var showWelcome: ShowWelcomeScreen
    
    @State private var searchData: SearchQueryData?
    @State private var loading: Bool = false
    
    @MainActor
    func fetchSearchResults(searchText: String) async {
        if loading {
            return
        }
        
        guard let apollo = Network.shared.apollo else {
            return
        }
        
        loading = true
        defer { loading = false }
        
        do {
            let data = try await apollo.asyncFetch(query: MediaSearchQuery(query: searchText))
            self.searchData = data.data?.search
        } catch {
            Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch search results", error: error), showWelcomeScreen: showWelcome)
        }
    }
    
    var body: some View {
        if isSearching && !searchText.isEmpty {
            Group {
                if let searchData = searchData {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 20) {
                            AlbumGrid(albums: searchData.albums.map { $0.fragments.albumItem })
                            //MediaGrid(onMediaAppear: nil)
                        }.padding(.vertical)
                    }
                } else {
                    ScrollView(.vertical) {
                        Text(self.loading ? "Loading..." : "No results")
                            .frame(maxWidth: .infinity)
                            .padding(.top)
                    }
                }
            }
            .background(.background)
            .onChange(of: searchText) { newValue in
                print("Search text changed!")
                Task {
                    await self.fetchSearchResults(searchText: newValue)
                }
            }
            .onAppear {
                print("Search text changed!")
                Task {
                    await self.fetchSearchResults(searchText: searchText)
                }
            }
        }
    }
}
