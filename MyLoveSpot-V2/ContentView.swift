//
//  ContentView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var spots: [Spots] = []
    @State private var selectedSpot: Spots? = nil

    var body: some View {
        TabView {
            SpotsView()
                .tabItem {
                    Label("Spots", systemImage: "mappin.and.ellipse")
                }
            MapView(spots: $spots, selectedSpot: $selectedSpot)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "star.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .onAppear {
            loadSpots()
        }
    }

    //TODO: Sample data, replace this by backend fetched data
    private func loadSpots() {
        spots = [
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
    }
}


#Preview {
    ContentView()
}
