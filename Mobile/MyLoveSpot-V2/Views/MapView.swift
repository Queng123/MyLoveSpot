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
                            spot.name,
                            systemImage: mapInfo.logo,
                            coordinate: mapInfo.coordinates
                        )
                        .tint(mapInfo.color)
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
