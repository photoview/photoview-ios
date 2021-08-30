//
//  PhotoviewApp.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import SwiftUI
import Apollo
import KeychainSwift

class ShowWelcomeScreen: ObservableObject {
  @Published var isPresented: Bool = false
}

@main
struct PhotoviewApp: App {
  @StateObject var showWelcomeScreen = ShowWelcomeScreen()
  
  var body: some Scene {
    WindowGroup {
      AppView(showWelcomeScreen: $showWelcomeScreen.isPresented)
        .fullScreenCover(isPresented: $showWelcomeScreen.isPresented) {
          WelcomeScreen(isPresented: $showWelcomeScreen.isPresented)
        }
        .onAppear {
          if (Network.shared.loadCredentials() == false) {
            showWelcomeScreen.isPresented = true
          }
        }
        .environmentObject(showWelcomeScreen)
    }
  }
}
