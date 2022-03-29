//
//  UIDevice+deviceType.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 19/02/2022.
//

import UIKit

extension UIDevice {
    static var isLargeScreen: Bool {
        UIDevice.current.userInterfaceIdiom != .phone
    }
}
