//
//  ContentView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SpotsView()
                .tabItem {
                    Label("Spots", systemImage: "mappin.and.ellipse")
                }
            
            MapView()
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
    }
}


#Preview {
    ContentView()
}
