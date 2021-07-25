//
//  SettingsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
      VStack {
        Text("Settings")
        Button(action: {
          Network.shared.clearCredentials()
        }, label: {
          Text("Log out")
        })
      }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
