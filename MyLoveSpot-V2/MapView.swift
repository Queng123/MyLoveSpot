//
//  MapView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Binding var spots: [Spots]
    @Binding var selectedSpot: Spots?

    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    )

    var body: some View {
        Map(position: $region, selection: $selectedSpot) {
            ForEach(spots) { spot in
                if let mapInfo = spot.mapInfo {
                        Marker(
                            spot.title,
                            systemImage: mapInfo.imageMarker,
                            coordinate: mapInfo.coordinates
                        )
                        .tint(mapInfo.colorMarker)
                        .tag(spot)
                    }
            }
        }.onAppear {
            locationManager.checkLocationAuthorization()
        }
        .onChange(of: locationManager.isAuthorized) {
            if let coordinate = locationManager.lastKnownLocation {
                region = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                )
            }
        }

    }
}

#Preview {
    struct MapViewPreview: View {
        @State private var spots = [
            Spots(title: "Spot 1", location: "Location 1", description: "Description 1",
                  mapInfo: Spots.MapInfo(imageMarker: "mappin", colorMarker: .red,
                                         coordinates: CLLocationCoordinate2D(latitude: 36.4476, longitude: -122.1623))),
            Spots(title: "Spot 2", location: "Location 2", description: "Description 2",
                  mapInfo: Spots.MapInfo(imageMarker: "mappin", colorMarker: .blue,
                                         coordinates: CLLocationCoordinate2D(latitude: 37.787394, longitude: -122.407633))),
            Spots(title: "Spot 3", location: "Location 3", description: "Description 3",
                  mapInfo: Spots.MapInfo(imageMarker: "mappin", colorMarker: .green,
                                         coordinates: CLLocationCoordinate2D(latitude: 37.7538253, longitude: -122.49082572609919)))
        ]
        @State private var selectedSpot: Spots? = nil

        var body: some View {
            MapView(spots: $spots, selectedSpot: $selectedSpot)
        }
    }

    return MapViewPreview()
}
