//
//  PlacesAnnotation.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import Foundation
import MapKit

class PlacesImageAnnotation: NSObject, MKAnnotation {
  let marker: PlacesMarker
  var title: String?
  
  @objc dynamic var coordinate: CLLocationCoordinate2D {
    marker.point.coordinate
  }
  
  init(marker: PlacesMarker) {
    self.marker = marker
    self.title = marker.properties.media_title
    super.init()
  }
  
  static func setupImageAnnotation(for annotation: PlacesImageAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
    let reuseIdentifier = NSStringFromClass(PlacesImageAnnotation.self)
    let imageAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as! PlacesImageAnnotationView
    
    return imageAnnotationView
  }
  
  static func setupClusterAnnotation(for annotation: MKClusterAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
//    let reuseIdentifier = NSStringFromClass(PlacesImageAnnotation.self)
    let reuseIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
    let imageAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as! PlacesImageAnnotationView
    
    return imageAnnotationView
  }
  
}
