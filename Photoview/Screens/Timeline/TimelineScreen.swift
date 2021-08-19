//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct TimelineScreen: View {
  
  @State var timelineData: [TimelineQuery.Data.MyTimeline]? = nil
  
  func fetchTimeline() {
    Network.shared.apollo?.fetch(query: TimelineQuery()) { result in
      switch (result) {
      case let .success(data):
        DispatchQueue.main.async {
          self.timelineData = data.data?.myTimeline
        }
      case let .failure(error):
        fatalError("Failed to fetch timeline: \(error)")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      if let timelineData = timelineData {
        TimelineView(timelineData: timelineData)
          .navigationTitle("Timeline")
      } else {
        ProgressView("Loading timeline")
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      if (timelineData == nil) {
        fetchTimeline()
      }
    }
  }
}

struct TimelineScreen_Previews: PreviewProvider {
  static var previews: some View {
    TimelineScreen()
  }
}
