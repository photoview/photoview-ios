//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct TimelineScreen: View {
  
  @State var timelineData: [TimelineQuery.Data.MyTimeline]? = nil
  @EnvironmentObject var showWelcome: ShowWelcomeScreen
  
  @State var offset = 0
  let limit = 200
  @State var moreToLoad = true
  @State var loading = false
  
  func fetchTimeline() {
    timelineData = []
    offset = 0
    moreToLoad = true
    loadMore()
  }
  
  func loadMore() {
    if !moreToLoad || loading {
      return
    }
    
    loading = true
    Network.shared.apollo?.fetch(query: TimelineQuery(limit: limit, offset: offset)) { result in
      switch (result) {
      case let .success(data):
        DispatchQueue.main.async {
          if (data.data?.myTimeline ?? []).isEmpty {
            moreToLoad = false
          }
          
          if var timelineData = self.timelineData {
            timelineData.append(contentsOf: data.data?.myTimeline ?? [])
            self.timelineData = timelineData
            print("load more appended, new size: \(timelineData.count)")
          } else {
            self.timelineData = data.data?.myTimeline
          }
          
          offset += limit
        }
      case let .failure(error):
        Network.shared.handleGraphqlError(error: error, showWelcomeScreen: showWelcome, message: "Failed to fetch timeline")
      }
      DispatchQueue.main.async {
        loading = false
      }
    }
  }
  
  var body: some View {
    NavigationView {
      if let timelineData = timelineData {
        TimelineView(timelineData: timelineData, loadMore: loadMore)
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
    .onChange(of: showWelcome.isPresented) { _ in
      if !showWelcome.isPresented {
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
