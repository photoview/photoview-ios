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
    
    @EnvironmentObject var showWelcome: ShowWelcomeScreen
    @State var mediaEnv: MediaEnvironment = MediaEnvironment()
    @State var locationName: String?
    
    func fetchPlacesMarkerDetails() {
        
        let ids = markers.map { GraphQLID($0.properties.media_id) }
        
        Network.shared.apollo?.fetch(query: PlacesClusterDetailsQuery(ids: ids)) { result in
            switch result {
            case let .success(data):
                mediaEnv.media = data.data?.mediaList.map { $0.fragments.mediaItem }
            case let .failure(error):
                Network.shared.handleGraphqlError(error: NetworkError(message: "Failed to fetch places marker details", error: error), showWelcomeScreen: showWelcome)
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
