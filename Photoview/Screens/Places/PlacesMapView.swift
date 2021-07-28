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
  
  enum SelectableAnnotation: Equatable {
    case image(marker: PlacesMarker, location: CLLocationCoordinate2D)
    case cluster(markers: [PlacesMarker], location: CLLocationCoordinate2D)
  }
  
  let markers: [PlacesMarker]
  @Binding var selectedAnnotation: SelectableAnnotation?
  
  func makeUIViewController(context: Context) -> PlacesMapViewController {
    return PlacesMapViewController(self)
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
  
  var controllerRepresentable: PlacesMapView
  var markerAnnotations: [PlacesImageAnnotation] = []
  
  init(_ representable: PlacesMapView) {
    self.controllerRepresentable = representable
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    let mapView = MKMapView()
    mapView.delegate = self
    
    mapView.register(PlacesImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlacesImageAnnotation.self))
    mapView.register(PlacesImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    
    view = mapView
  }
  
  func updateMarkers(newMarkers: [PlacesMarker]) {
    let newAnnotations = newMarkers.map { PlacesImageAnnotation(marker: $0) }
    
    if newAnnotations.count != markerAnnotations.count {
      print("Annotation count is different: \(newAnnotations.count) \(markerAnnotations.count)")
      mapView.removeAnnotations(markerAnnotations)
      mapView.addAnnotations(newAnnotations)
      self.markerAnnotations = newAnnotations
    }
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
    
    if let annotation = view.annotation as? MKClusterAnnotation, let markers = annotation.memberAnnotations as? [PlacesImageAnnotation] {
      controllerRepresentable.selectedAnnotation = PlacesMapView.SelectableAnnotation.cluster(markers: markers.map { $0.marker }, location: annotation.coordinate)
    }
    
    if let annotation = view.annotation as? PlacesImageAnnotation {
      controllerRepresentable.selectedAnnotation = PlacesMapView.SelectableAnnotation.image(marker: annotation.marker, location: annotation.coordinate)
    }
    
  }
}
