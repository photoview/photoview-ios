//
//  WelcomeScreenView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import SwiftUI

struct WelcomeScreenView: View {
  @State private var credentials: CredentialsModel = CredentialsModel()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20.0) {
        VStack(alignment: .center) {
          Image("Logo")
            .resizable()
            .frame(width: 100, height: 100)
          Text("Welcome to Photoview").font(.title)
          Text("Connect to your instance")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48.0)
        
        VStack(alignment: .leading, spacing: 8.0) {
          Text("Instance").font(.caption)
          TextField("https://example.com", text: $credentials.username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textContentType(.URL)
        }
        
        VStack(alignment: .leading, spacing: 8.0) {
          Text("Username").font(.caption)
          TextField("username", text: $credentials.username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textContentType(.username)
        }
        
        VStack(alignment: .leading, spacing: 8.0) {
          Text("Password").font(.caption)
          SecureField("••••••••", text: $credentials.password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textContentType(.password)
        }
        
        Button("Connect") {}
          .buttonStyle(PrimaryButtonStyle())

      }.padding(.horizontal)
    }
  }
}

struct WelcomeScreenView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeScreenView()
  }
}
