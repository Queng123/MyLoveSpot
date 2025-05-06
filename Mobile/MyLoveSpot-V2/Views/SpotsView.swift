//
//  SpotsView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI
import MapKit

struct SpotsView: View {
    @Binding var spots: [Spots]
    @State private var searchText = ""
    @Binding var selectedSpot: Spots?
    @StateObject private var locationManager = LocationManager()
    
    @State private var searchScale: CGFloat = 1.0
    @State private var showSearchModule = false
    @State private var showingSpotDetail = false
    @State private var showingNewSpotForm = false
    
    private func indexForSpot(_ spot: Spots) -> Int? {
        return spots.firstIndex(where: { $0.id == spot.id })
    }
    
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
                                        showingSpotDetail = true
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
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingNewSpotForm = true
                        }) {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
                .opacity(showSearchModule ? 0 : 1)
            }
            .navigationBarHidden(true)
            .onAppear {
                locationManager.checkLocationAuthorization()
            }
            .sheet(isPresented: $showingSpotDetail) {
                if let spot = selectedSpot, let index = indexForSpot(spot) {
                    SpotDetailView(spot: $spots[index])
                }
            }
        }
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
                    Text(spot.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                    
                    Text(spot.rating, format: .number.precision(.fractionLength(1)))
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
