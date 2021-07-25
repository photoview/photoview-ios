//
//  ShareDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct ShareDetailsView: View {
  var body: some View {
    Section(header: Text("Share")) {
      Text("No shares found").italic().foregroundColor(.secondary)
      
      Button(action: {}, label: {
        Label("Add share", systemImage: "plus")
      })
      .foregroundColor(Color(UIColor.systemGreen))
    }
  }
}

struct ShareDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    List {
      ShareDetailsView()
    }
    .listStyle(InsetGroupedListStyle())
  }
}
