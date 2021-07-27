//
//  PlacesMapView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import SwiftUI
import UIKit
import MapKit

struct PlacesMapView: UIViewControllerRepresentable {
  
  let markers: [PlacesMarker]
  
  func makeUIViewController(context: Context) -> PlacesMapViewController {
    return PlacesMapViewController()
  }
  
  func updateUIViewController(_ viewController: PlacesMapViewController, context: Context) {
    print("Update place map view")
    viewController.updateMarkers(newMarkers: markers)
  }
}

class PlacesMapViewController: UIViewController {
  
  var mapView: MKMapView {
    view as! MKMapView
  }
  
  override func loadView() {
    let mapView = MKMapView()
    mapView.delegate = self
    
    mapView.register(PlacesImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlacesImageAnnotation.self))
    
    view = mapView
  }
  
  func updateMarkers(newMarkers: [PlacesMarker]) {
    let annotations = newMarkers.map { PlacesImageAnnotation(marker: $0) }
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotations(annotations)
  }
  
}

extension PlacesMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    guard !annotation.isKind(of: MKUserLocation.self) else {
      // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
      return nil
    }
    
    var annotationView: MKAnnotationView?
    
    if let annotation = annotation as? PlacesImageAnnotation {
      annotationView = PlacesImageAnnotation.setupImageAnnotation(for: annotation, on: mapView)
    }
    
    if let annotation = annotation as? MKClusterAnnotation {
      annotationView = PlacesImageAnnotation.setupClusterAnnotation(for: annotation, on: mapView)
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("Annotation selected")
  }
}
