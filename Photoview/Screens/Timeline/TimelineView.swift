//
//  TimelineView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/08/2021.
//

import SwiftUI
import Apollo

class TimelineState: ObservableObject {
  @Published var mediaEnvs: [TimelineAlbumGroup: MediaEnvironment] = [:]
  
  func buildMediaEnvs(albumGroups: [TimelineAlbumGroup]) {
    
    for albumGroup in albumGroups {
      let media = try! albumGroup.media.map(MediaEnvironment.Media.from)
      mediaEnvs[albumGroup] = MediaEnvironment(media: media, activeMediaIndex: 0)
    }
    
    print("Finished building media envs: \(mediaEnvs.count)")
  }
}

struct TimelineAlbumGroup: Identifiable, Hashable {
  var id: Self {
    self
  }
  
  let albumID: GraphQLID
  let title: String
  let day: Date
  var media: [TimelineQuery.Data.MyTimeline]
  
  static func == (lhs: TimelineAlbumGroup, rhs: TimelineAlbumGroup) -> Bool {
    return lhs.albumID == rhs.albumID && lhs.day == rhs.day
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(albumID)
    hasher.combine(day)
  }
}

struct TimelineView: View {
  
  let timelineData: [TimelineQuery.Data.MyTimeline]
  @StateObject var timelineState: TimelineState = TimelineState()
  
  var timelineAlbums: [TimelineAlbumGroup] {
    
    var albums: [TimelineAlbumGroup] = []
    
    guard let firstMedia = timelineData.first else {
      return []
    }
    
    var nextAlbum: TimelineAlbumGroup = TimelineAlbumGroup(albumID: firstMedia.album.id, title: firstMedia.album.title, day: Calendar.current.startOfDay(for: firstMedia.date.date), media: [firstMedia])
    
    for media in timelineData.dropFirst() {
      let mediaDay = Calendar.current.startOfDay(for: media.date.date)
      
      if mediaDay == nextAlbum.day && media.album.id == nextAlbum.albumID {
        nextAlbum.media.append(media)
      } else {
        albums.append(nextAlbum)
        nextAlbum = TimelineAlbumGroup(albumID: media.album.id, title: media.album.title, day: Calendar.current.startOfDay(for: media.date.date), media: [media])
      }
    }
    
    albums.append(nextAlbum)
    
    return albums
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    
    return formatter
  }()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ForEach(timelineAlbums, id: \.id) { albumGroup in
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
              MediaGrid()
                .environmentObject(mediaEnv)
            }
          }
        }
      }
    }
    //    .listStyle(GroupedListStyle())
    .onAppear {
      timelineState.buildMediaEnvs(albumGroups: timelineAlbums)
    }
  }
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineView(timelineData: [])
  }
}
