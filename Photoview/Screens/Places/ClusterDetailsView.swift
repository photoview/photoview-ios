//
//  ClusterDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 28/07/2021.
//

import SwiftUI
import MapKit
import Apollo

struct ClusterDetailsView: View {
  
  let markers: [PlacesMarker]
  let location: CLLocationCoordinate2D?
  
  @State var mediaEnv: MediaEnvironment = MediaEnvironment()
  @State var locationName: String?
  
  func fetchPlacesMarkerDetails() {
    
    let ids = markers.map { GraphQLID($0.properties.media_id) }
    
    Network.shared.apollo?.fetch(query: PlacesClusterDetailsQuery(ids: ids)) { result in
      switch result {
      case let .success(data):
        let media = try! data.data?.mediaList.map(MediaEnvironment.Media.from)
        mediaEnv.media = media
      case let .failure(error):
        fatalError("Failed to fetch places marker details: \(error)")
      }
    }
  }
  
  func fetchLocationName() {
    guard let coords = location else { return }
    
    let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
    let geoCoder = CLGeocoder()
    
    geoCoder.reverseGeocodeLocation(location) { places, error in
      if let error = error {
        print("Fetch cluster location name error: \(error)")
      }
      
      
      if let place = places?.first, let locality = place.locality, let country = place.country {
        DispatchQueue.main.async {
          self.locationName = "\(locality), \(country)"
        }
      }
      
    }
  }
  
  var body: some View {
    ScrollView {
      MediaGrid()
    }
    .onAppear {
      fetchPlacesMarkerDetails()
      fetchLocationName()
    }
    .environmentObject(mediaEnv)
    .navigationTitle(locationName ?? "Places Media")
  }
}

struct ClusterDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    ClusterDetailsView(markers: [], location: nil)
  }
}
