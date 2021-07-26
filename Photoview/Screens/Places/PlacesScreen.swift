//
//  PlacesView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import MapKit

struct PlacesMarker: Identifiable {
  var id: UUID = UUID()
  let point: MKPointAnnotation
  let properties: MarkerProperties
}

struct MarkerProperties: Codable {
  let media_id: Int
  let media_title: String
  let thumbnail: Thumbnail
  
  struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
  }
}

struct PlacesScreen: View {
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 0,
      longitude: 0
    ),
    span: MKCoordinateSpan(
      latitudeDelta: 7,
      longitudeDelta: 7
    )
  )
  
  @State var markers: [PlacesMarker] = []
  
  func fetchGeoJson() {
    Network.shared.apollo?.fetch(query: MediaGeoJsonQuery()) { result in
      switch result {
      case .success(let data):
        guard let geojsonRaw = data.data?.myMediaGeoJson else { fatalError("geojson data is empty") }
        guard let geojsonData = geojsonRaw.value.data(using: .utf8) else { fatalError("failed to encode geojson string")}
        guard let geojson = try? MKGeoJSONDecoder().decode(geojsonData) else { fatalError("failed to decode geojson") }
        
        let decoder = JSONDecoder()
        var newMarkers: [PlacesMarker] = []
        
//        var count = 25;
        
        for item in geojson {
          
//          if count == 0 {
//            break
//          } else {
//            count -= 1
//          }
          
          guard let feature = item as? MKGeoJSONFeature else { continue }
          guard let propData = feature.properties else { continue }
          guard let properties = try? decoder.decode(MarkerProperties.self, from: propData) else { continue }
          guard let point = (feature.geometry as? [MKPointAnnotation])?.first else { continue }
          
          newMarkers.append(PlacesMarker(point: point, properties: properties))
        }
        
        markers = newMarkers
        
      case .failure(let error):
        fatalError("Failed to fetch geojson: \(error)")
      }
    }
  }
  
  var body: some View {
    PlacesMapView(markers: markers)
//    Map(coordinateRegion: $region, annotationItems: markers) { marker in
//      MapAnnotation(coordinate: marker.point.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
//        Circle()
//          .stroke(Color.green)
//          .frame(width: 44, height: 44)
//      }
//    }
    .ignoresSafeArea()
    .onAppear {
      fetchGeoJson()
    }
  }
}

struct PlacesScreen_Previews: PreviewProvider {
  static var previews: some View {
    PlacesScreen()
  }
}
