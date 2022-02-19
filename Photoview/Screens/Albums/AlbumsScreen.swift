//
//  AlbumView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AlbumsScreen: View {
    
    typealias AlbumQueryData = MyAlbumsQuery.Data.MyAlbum
    
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    @State var albumData: [AlbumQueryData] = []
    
    func fetchMyAlbums() {
        Network.shared.apollo?.fetch(query: MyAlbumsQuery()) { result in
            switch(result) {
            case let .success(data):
                DispatchQueue.main.async {
                    // albumData = data.data?.album
                    albumData = data.data?.myAlbums ?? []
                }
            case let .failure(error):
                Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch my albums", error: error), showWelcomeScreen: showWelcome)
            }
        }
    }
    
    var body: some View {
        MediaSidebarView(mediaEnv: nil) {
            ScrollView(.vertical, showsIndicators: true) {
                AlbumGrid(albums: albumData.map { $0.fragments.albumItem })
                    .navigationTitle("My albums")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if (albumData.isEmpty) {
                fetchMyAlbums()
            }
        }
    }
}

struct AlbumsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            AlbumsScreen()
        }
    }
}
