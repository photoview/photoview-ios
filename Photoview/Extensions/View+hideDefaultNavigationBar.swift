//
//  View+hideDefaultNavigationBar.swift
//  Photoview
//
//  Created by Dhrumil Shah on 3/2/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideDefaultNavigationBar() -> some View {
        if #available(iOS 16, *) {
            self.toolbar(.hidden)
        }
        else {
            self.navigationBarHidden(true)
        }
    }
}
