//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/08/2021.
//

import SwiftUI

struct TimelineView: View {
    @ObservedObject var timelineState: TimelineState
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    
    @State var activeMediaEnv: MediaEnvironment?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter
    }()
    
    func timelineSection(albumGroup: TimelineAlbumGroup) -> some View {
        Section(header:
            NavigationLink(destination: AlbumView(albumID: albumGroup.albumID, albumTitle: albumGroup.title)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: albumGroup.day))
                            .foregroundColor(.secondary)
                        Text(albumGroup.title)
                            .foregroundColor(.primary)
                            .font(.headline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding([.horizontal, .top])
        ) {
            if let mediaEnv = timelineState.mediaEnvs[albumGroup] {
                MediaGrid(onMediaAppear: { media in
                    Task {
                        do {
                            try await timelineState.loadMoreIfNeeded(albumGroup: albumGroup, mediaIndex: mediaEnv.mediaIndex(media))
                        } catch {
                            Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch timeline", error: error),
                                                              showWelcomeScreen: showWelcome)
                        }
                    }
                }, onMediaSelected: { _ in
                    self.activeMediaEnv = mediaEnv
                })
                    .environmentObject(mediaEnv)
            }
        }
    }
    
    var body: some View {
        MediaSidebarView(mediaEnv: activeMediaEnv) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    ForEach(self.timelineState.timelineAlbums, id: \.id) { albumGroup in
                        timelineSection(albumGroup: albumGroup)
                    }
                }
            }
            .navigationTitle("Timeline")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(timelineState: TimelineState())
    }
}
