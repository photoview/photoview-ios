//
//  View+if.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import SwiftUI

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
