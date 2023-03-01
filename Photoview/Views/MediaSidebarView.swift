//
//  SidebarView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/02/2022.
//

import SwiftUI

struct MediaSidebarView<ContentView>: View where ContentView: View {
    
    var mediaEnv: MediaEnvironment?
    @State private var searchValue: String = ""
    
    let content: () -> ContentView
    
    var mainContent: some View {
        NavigationView {
            content()
            .overlay {
                SearchResultsOverlay(searchText: $searchValue)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $searchValue)
    }
    
    @ViewBuilder
    var sidebar: some View {
        if let mediaEnv = mediaEnv, mediaEnv.activeMedia != nil {
            MediaDetailsView(mediaEnv: mediaEnv)
        } else {
            Text("Empty sidebar").padding()
        }
    }
    
    var splitView: some View {
        HStack(alignment: .top, spacing: 0) {
            mainContent
            sidebar.frame(width: mediaEnv != nil ? 360 : 0)
        }
        .overlay {
            SearchResultsOverlay(searchText: $searchValue)
        }
    }
    
    var body: some View {
        if UIDevice.isLargeScreen {
            splitView
        } else {
            mainContent
        }
    }
}

//struct SidebarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarView()
//    }
//}
