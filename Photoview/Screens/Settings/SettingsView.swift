//
//  SettingsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct SettingsScreen: View {
  @Binding var showWelcomeScreen: Bool
  
  var body: some View {
    NavigationView {
      List {
        Button(action: {
          Network.shared.clearCredentials()
          showWelcomeScreen = true
        }, label: {
          Label("Log out", systemImage: "lock")
        })
      }
      .navigationTitle("Settings")
    }
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen(showWelcomeScreen: .constant(false))
  }
}
