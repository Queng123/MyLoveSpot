//
//  SpotsView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI
import MapKit

struct SpotsView: View {
    @State private var spots: [Spots] = []
    @State private var searchText = ""
    @State private var selectedSpot: Spots? = nil
    @StateObject private var locationManager = LocationManager()
    
    @State private var searchScale: CGFloat = 1.0
    @State private var showSearchModule = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            
                            Text(searchText.isEmpty ? "Search" : searchText)
                                .foregroundColor(searchText.isEmpty ? .gray : .black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        searchScale = 1.1
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showSearchModule = true
                                            }
                                        }
                                    }
                                }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .padding()
                        .scaleEffect(searchScale)
                        .opacity(showSearchModule ? 0 : 1)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring()) {
                                    searchScale = 1.1

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showSearchModule = true
                                        }
                                    }
                                }
                            }) {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.white)
                                    )
                            }
                            .padding(.trailing, 25)
                            .opacity(showSearchModule ? 0 : 1)
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(spots) { spot in
                                SpotCard(spot: spot, userLocation: locationManager.lastKnownLocation)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedSpot = spot
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .blur(radius: showSearchModule ? 3 : 0)

                if showSearchModule {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSearchModule = false
                                searchScale = 1.0
                            }
                        }
                    
                    SearchModule(isShowing: $showSearchModule, searchText: $searchText)
                        .padding()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadSpots()
                locationManager.checkLocationAuthorization()
            }
            .sheet(item: $selectedSpot) { spot in
                SpotDetailView(spot: spot)
            }
        }
    }
    
    private func loadSpots() {
        spots = [
            Spots(title: "UC Berkeley botanical garden", location: "Berkeley, CA", description: "Beautiful garden in the Berkeley hills with a diverse collection of plants from around the world.",
                  mapInfo: Spots.MapInfo(imageMarker: "leaf", colorMarker: .green,
                                      coordinates: CLLocationCoordinate2D(latitude: 37.8759, longitude: -122.2393))),
            Spots(title: "Baker Beach", location: "San Francisco, CA", description: "Sandy beach with stunning views of the Golden Gate Bridge, especially at sunset.",
                  mapInfo: Spots.MapInfo(imageMarker: "mappin", colorMarker: .blue,
                                      coordinates: CLLocationCoordinate2D(latitude: 37.7930, longitude: -122.4837))),
            Spots(title: "Twin Peaks", location: "San Francisco, CA", description: "Famous hills offering panoramic views of the San Francisco Bay Area.",
                  mapInfo: Spots.MapInfo(imageMarker: "mountain.2", colorMarker: .orange,
                                      coordinates: CLLocationCoordinate2D(latitude: 37.7544, longitude: -122.4477))),
            Spots(title: "Muir Woods", location: "Mill Valley, CA", description: "National monument known for its towering old-growth redwood trees.",
                  mapInfo: Spots.MapInfo(imageMarker: "tree", colorMarker: .green,
                                      coordinates: CLLocationCoordinate2D(latitude: 37.8912, longitude: -122.5719))),
            Spots(title: "Fisherman's Wharf", location: "San Francisco, CA", description: "Popular waterfront area with seafood restaurants, shops, and sea lion viewing.",
                  mapInfo: Spots.MapInfo(imageMarker: "water.waves", colorMarker: .blue,
                                      coordinates: CLLocationCoordinate2D(latitude: 37.8080, longitude: -122.4177)))
        ]
    }
}

struct SpotCard: View {
    let spot: Spots
    let userLocation: CLLocationCoordinate2D?
    
    var distanceText: String {
        guard let userLocation = userLocation, let spotCoordinates = spot.mapInfo?.coordinates else {
            return "-- min away"
        }
        
        let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let spotLocationCL = CLLocation(latitude: spotCoordinates.latitude, longitude: spotCoordinates.longitude)
        
        let distanceInMeters = userLocationCL.distance(from: spotLocationCL)
        let distanceInMinutes = Int(distanceInMeters / 13.8 / 60)
        
        return "\(distanceInMinutes) min away"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(spot.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                    
                    Text("4.9")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "arrow.forward")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(-45))
                    
                    Text(distanceText)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Image(systemName: "person.2")
                        .foregroundColor(.gray)
                    
                    Text("2.3k")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SpotDetailView: View {
    let spot: Spots
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(spot.title)
                .font(.title)
                .padding()
            
            Text(spot.description)
                .padding()
            
            Spacer()
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}

#Preview {
    SpotsView()
}
