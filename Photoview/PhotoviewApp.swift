//
//  PhotoviewApp.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import SwiftUI
import Apollo
import KeychainSwift

@main
struct PhotoviewApp: App {
  @State var showWelcomeScreen = false
  
  var body: some Scene {
    WindowGroup {
      AppView(showWelcomeScreen: $showWelcomeScreen)
        .fullScreenCover(isPresented: $showWelcomeScreen) {
          WelcomeScreen(isPresented: $showWelcomeScreen)
        }
        .onAppear {
          if (Network.shared.loadCredentials() == false) {
            showWelcomeScreen = true
          }
        }
    }
  }
}
