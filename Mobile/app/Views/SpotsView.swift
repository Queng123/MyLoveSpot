//
//  SpotsView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI
import MapKit

struct SpotsView: View {
    @ObservedObject var store: SpotsStore
    @State private var searchText = ""
    @Binding var selectedSpot: Spots?
    @Binding var tags: [Tag]
    @StateObject private var locationManager = LocationManager()
    
    @State private var searchScale: CGFloat = 1.0
    @State private var showSearchModule = false
    @State private var showingSpotDetail = false
    @State private var showingNewSpotForm = false
    
    private func indexForSpot(_ spot: Spots) -> Int? {
        return store.spots.firstIndex(where: { $0.id == spot.id })
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
                            ForEach($store.spots) { $spot in
                                SpotCard(spot: $spot, userLocation: locationManager.lastKnownLocation)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedSpot = spot
                                        print("selected spot: \(spot.name)")
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
            .sheet(item: $selectedSpot) { spot in
                SpotDetailView(selectedSpot: .constant(spot), store: store)
            }.sheet(isPresented: $showingNewSpotForm) {
                NewSpotFormView(store: store, isPresented: $showingNewSpotForm, tags: $tags)
            }
        }
    }
}
