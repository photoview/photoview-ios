//
//  PrimaryButton.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
  
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    PrimaryButton(configuration: configuration)
  }
  
  struct PrimaryButton: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      configuration
        .label
        .frame(maxWidth: .infinity)
        .padding(12.0)
        .background(Color.blue.opacity(configuration.isPressed || !isEnabled ? 0.8 : 1.0))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
  }
}
