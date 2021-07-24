//
//  AppView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct AppView: View {
    var body: some View {
      TabView {
        TimelineScreen()
          .tabItem {
            Image(systemName: "photo.fill")
            Text("Timeline")
          }
        AlbumsScreen()
          .tabItem {
            Image(systemName: "photo.fill.on.rectangle.fill")
            Text("Albums")
          }
        PlacesScreen()
          .tabItem {
            Image(systemName: "map.fill")
            Text("Places")
          }
        PeopleScreen()
          .tabItem {
            Image(systemName: "person.3.fill")
            Text("People")
          }
        SettingsScreen()
          .tabItem {
            Image(systemName: "gearshape.fill")
            Text("Settings")
          }
      }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
