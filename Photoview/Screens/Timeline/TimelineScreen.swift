//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct TimelineScreen: View {
    
    @StateObject var timelineState: TimelineState = TimelineState()
    
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    
    func fetchTimeline() async {
        do {
            try await timelineState.fetchTimeline()
        } catch {
            Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch timeline", error: error),
                                              showWelcomeScreen: showWelcome)
        }
    }
    
    var body: some View {
        TimelineView(timelineState: timelineState)
        .task {
            if (timelineState.timelineData == nil) {
               await fetchTimeline()
            }
        }
        .onChange(of: showWelcome.isPresented) { _ in
            if !showWelcome.isPresented {
                Task { await fetchTimeline() }
            }
        }
    }
}

struct TimelineScreen_Previews: PreviewProvider {
    static var previews: some View {
        TimelineScreen()
    }
}
