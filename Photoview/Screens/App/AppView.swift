//
//  AppView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AppView: View {
  
  @Binding var showWelcomeScreen: Bool
  @State var selectedTab = 1
  
  func tabAccentColor() -> Color {
    switch selectedTab {
    case 1:
      return Color("TabTimeline")
    case 2:
      return Color("TabAlbums")
    case 3:
      return Color("TabPlaces")
    case 4:
      return Color("TabPeople")
    default:
      return Color("TabSettings")
    }
  }
  
  var body: some View {
    TabView(selection: $selectedTab) {
      TimelineScreen()
        .tabItem {
          Image(systemName: "photo.fill")
          Text("Timeline")
        }
        .tag(1)
      AlbumsScreen()
        .tabItem {
          Image(systemName: "photo.fill.on.rectangle.fill")
          Text("Albums")
        }
        .tag(2)
      PlacesScreen()
        .tabItem {
          Image(systemName: "map.fill")
          Text("Places")
        }
        .tag(3)
      PeopleScreen()
        .tabItem {
          Image(systemName: "person.3.fill")
          Text("People")
        }
        .tag(4)
      SettingsScreen(showWelcomeScreen: $showWelcomeScreen)
        .tabItem {
          Image(systemName: "gearshape.fill")
          Text("Settings")
        }
        .tag(5)
    }
    .accentColor(tabAccentColor())
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(showWelcomeScreen: .constant(false))
  }
}
