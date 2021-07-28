//
//  Mapkit+Equatable.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
