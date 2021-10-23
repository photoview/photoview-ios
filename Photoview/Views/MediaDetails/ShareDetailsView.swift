//
//  ShareDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct ShareDetailsView: View {
  
  typealias Share = MediaDetailsQuery.Data.Medium.Share
  
  let mediaID: String
  let shares: [Share]
  let refreshMediaDetails: () -> Void
  
  @EnvironmentObject var showWelcome: ShowWelcomeScreen
  @State var presentedShareMenu: String? = nil
  
  func deleteShare(_ share: Share) {
    Network.shared.apollo?.perform(mutation: DeleteShareTokenMutation(token: share.token)) { result in
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          refreshMediaDetails()
        }
      case let .failure(error):
        Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to delete share token", error: error), showWelcomeScreen: showWelcome)
      }
    }
  }
  
  func addShare() {
    Network.shared.apollo?.perform(mutation: ShareMediaMutation(id: mediaID)) { result in
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          refreshMediaDetails()
        }
      case let .failure(error):
        Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to add share token", error: error), showWelcomeScreen: showWelcome)
      }
    }
  }
  
  var body: some View {
    Section(header: Text("Share")) {
      if shares.isEmpty {
        Text("No shares found").italic().foregroundColor(.secondary)
      } else {
        ForEach(shares, id: \.id) { share in
          
          let isPresented = Binding(
            get: { presentedShareMenu == share.id },
            set: {
              if $0 == false {
                presentedShareMenu = nil
              } else {
                presentedShareMenu = share.id
              }
            }
          )
          
          Button(action: { presentedShareMenu = share.id }, label: {
            Label(share.token, systemImage: "link")
          })
          .actionSheet(isPresented: isPresented, content: {
            ActionSheet(title: Text("Share \(share.token)"), message: nil, buttons: [
              .cancel(),
              .default(Text("Copy URL")) {
                guard var instanceUrl = Network.shared.serverInstanceURL else { return }
                
                instanceUrl.deleteLastPathComponent() // "graphql"
                if instanceUrl.lastPathComponent == "api" {
                  instanceUrl.deleteLastPathComponent()
                }
                
                instanceUrl.appendPathComponent("share")
                instanceUrl.appendPathComponent(share.token)
                
                UIPasteboard.general.string = instanceUrl.absoluteString
              },
              .destructive(Text("Delete share")) {
                deleteShare(share)
              }
            ])
          })
        }
      }
      
      Button(action: { addShare() }, label: {
        Label("Add share", systemImage: "plus")
      })
      .foregroundColor(Color(UIColor.systemGreen))
    }
  }
}

struct ShareDetailsView_Previews: PreviewProvider {
  
  static let sampleShares = [
    MediaDetailsQuery.Data.Medium.Share(id: "1", token: "rMHkKhmX"),
    MediaDetailsQuery.Data.Medium.Share(id: "2", token: "5RkqfYTQ"),
    MediaDetailsQuery.Data.Medium.Share(id: "3", token: "oSLPKNj3"),
  ]
  
  static var previews: some View {
    NavigationView {
      List {
        ShareDetailsView(mediaID: "123", shares: sampleShares, refreshMediaDetails: {})
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
}
