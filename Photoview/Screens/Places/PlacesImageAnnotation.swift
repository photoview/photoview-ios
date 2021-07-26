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
  
  static func setupAnnotation(for annotation: PlacesImageAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
    let reuseIdentifier = NSStringFromClass(PlacesImageAnnotation.self)
    let imageAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as! PlacesImageAnnotationView
    
//    imageAnnotationView.canShowCallout = true
//
//    // Provide the annotation view's image.
//    let image = UIImage(systemName: "gear")!
//    imageAnnotationView.image = image
//
//    // Provide the left image icon for the annotation.
////    imageAnnotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(systemName: "person")!)
//
//    // Offset the flag annotation so that the flag pole rests on the map coordinate.
//    let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
//    imageAnnotationView.centerOffset = offset
    
    return imageAnnotationView
  }
  
}
