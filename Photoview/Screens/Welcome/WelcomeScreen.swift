//
//  WelcomeScreen.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 21/07/2021.
//

import SwiftUI

struct WelcomeScreen: View {
    @State private var credentials: CredentialsModel = CredentialsModel()
    @State private var errorMessage: String? = nil
    @Binding var isPresented: Bool
    
    enum FocusableWelcomeFields {
        case instance
        case username
        case password
    }
    
    @FocusState private var focus: FocusableWelcomeFields?
    
    private func connectAction() {
        print("Connect action")
        Network.shared.authorize(credentials: credentials) { result in
            switch result {
            case .success:
                print("Successfully logged in")
                DispatchQueue.main.async {
                    isPresented = false
                }
            case .failure(let msg):
                print("Failure: \(msg)")
                DispatchQueue.main.async {
                    errorMessage = msg
                }
            }
        }
    }
    
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
                    TextField("https://example.com", text: $credentials.instance)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .instance)
                        .onSubmit {
                            focus = .username
                        }
                        .submitLabel(.next)
                }
                
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("Username").font(.caption)
                    TextField("username", text: $credentials.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .username)
                        .onSubmit {
                            focus = .password
                        }
                        .submitLabel(.next)
                }
                
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("Password").font(.caption)
                    SecureField("password", text: $credentials.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focus, equals: .password)
                        .onSubmit {
                            connectAction()
                        }
                        .submitLabel(.go)
                }
                
                Button("Connect", action: connectAction)
                    .buttonStyle(PrimaryButtonStyle())
                
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
            }
            .padding(.horizontal)
            .padding(.bottom, 20.0)
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(isPresented: .constant(true))
    }
}
