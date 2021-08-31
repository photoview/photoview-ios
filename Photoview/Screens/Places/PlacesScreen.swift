//
//  PlacesView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI
import MapKit
import Apollo

struct PlacesMarker: Identifiable, Equatable {
  var id: UUID = UUID()
  let point: MKPointAnnotation
  let properties: MarkerProperties
}

struct MarkerProperties: Codable, Equatable {
  let media_id: Int
  let media_title: String
  let thumbnail: Thumbnail
  
  struct Thumbnail: Codable, Equatable {
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
  @State var selectedAnnotation: PlacesMapView.SelectableAnnotation? = nil
  
  @StateObject var mediaEnv = MediaEnvironment()
  
  func fetchGeoJson() {
    Network.shared.apollo?.fetch(query: MediaGeoJsonQuery()) { result in
      switch result {
      case .success(let data):
        guard let geojsonRaw = data.data?.myMediaGeoJson else {
          print("geojson data is empty")
          markers = []
          selectedAnnotation = nil
          return
        }
        guard let geojsonData = geojsonRaw.value.data(using: .utf8) else { fatalError("failed to encode geojson string")}
        guard let geojson = try? MKGeoJSONDecoder().decode(geojsonData) else { fatalError("failed to decode geojson") }
        
        let decoder = JSONDecoder()
        var newMarkers: [PlacesMarker] = []
        
        for item in geojson {
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
    let clusterNavigationActive = Binding(
      get: { () -> Bool in
        if case .cluster = self.selectedAnnotation {
          return true
        } else {
          return false
        }
      },
      set: {
        if $0 == false {
          self.selectedAnnotation = nil
        }
      }
    )
    
    let clusterMarkers = self.selectedAnnotation.map { annotation -> [PlacesMarker] in
      if case let .cluster(markers, _) = annotation {
        return markers
      } else {
        return []
      }
    } ?? []
    
    let clusterLocation = self.selectedAnnotation.map { annotation -> CLLocationCoordinate2D? in
      if case let .cluster(_, location) = annotation {
        return location
      } else {
        return nil
      }
    } ?? nil
    
    let imageNavigationActive = Binding(
      get: { () -> Bool in
        !(mediaEnv.media ?? []).isEmpty
      },
      set: {
        if $0 == false {
          self.selectedAnnotation = nil
          self.mediaEnv.media = nil
        }
      }
    )
    
    NavigationView {
      ZStack {
        PlacesMapView(markers: markers, selectedAnnotation: $selectedAnnotation)
          .ignoresSafeArea()
        NavigationLink(destination: ClusterDetailsView(markers: clusterMarkers, location: clusterLocation), isActive: clusterNavigationActive, label: { EmptyView() })
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      fetchGeoJson()
    }
    .sheet(isPresented: imageNavigationActive) {
      MediaDetailsView()
        // can crash without this
        .environmentObject(mediaEnv)
    }
    .onChange(of: selectedAnnotation) { newAnnotation in
      if case let .image(marker, _) = newAnnotation {
        print("Update media env")
        mediaEnv.media = [MediaEnvironment.Media(id: GraphQLID(marker.properties.media_id), thumbnail: .init(url: marker.properties.thumbnail.url, width: marker.properties.thumbnail.width, height: marker.properties.thumbnail.height), favorite: false)]
      }
    }
  }
}

struct PlacesScreen_Previews: PreviewProvider {
  static var previews: some View {
    PlacesScreen()
  }
}
