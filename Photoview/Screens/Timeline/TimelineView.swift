//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/08/2021.
//

import SwiftUI

class TimelineState: ObservableObject {
  @Published var mediaEnvs: [Time: MediaEnvironment] = [:]
  
  func buildMediaEnvs(timelineData: [TimelineQuery.Data.MyTimeline]) {
    for day in timelineData {
      let media = try! day.media.map(MediaEnvironment.Media.from)
      mediaEnvs[day.date] = MediaEnvironment(media: media, activeMediaIndex: 0)
    }
    
    print("Finished building media envs: \(mediaEnvs.count)")
  }
}



struct TimelineView: View {
  
  let timelineData: [TimelineQuery.Data.MyTimeline]
  @StateObject var timelineState: TimelineState = TimelineState()
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    
    return formatter
  }()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ForEach(timelineData, id: \.media.first?.id) { day in
          Section(header:
                    NavigationLink(destination: AlbumView(albumID: day.album.id, albumTitle: day.album.title)) {
                      HStack {
                        VStack(alignment: .leading) {
                          Text(dateFormatter.string(from: day.date.date))
                            .foregroundColor(.secondary)
                          Text(day.album.title)
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
            if let mediaEnv = timelineState.mediaEnvs[day.date] {
              MediaGrid()
                .environmentObject(mediaEnv)
            }
          }
        }
      }
    }
    //    .listStyle(GroupedListStyle())
    .onAppear {
      timelineState.buildMediaEnvs(timelineData: timelineData)
    }
  }
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineView(timelineData: [])
  }
}
