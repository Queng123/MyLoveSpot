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
            SpotsView(spots: $spots, selectedSpot: $selectedSpot)
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

    private func loadSpots() {
        guard let url = URL(string: "http://127.0.0.1:3000/spot/all") else {
            print("Wrong URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error fetching data")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            print("Data fetched successfully! (Yay!)")
            print(String(data: data, encoding: .utf8) ?? "No data")
            
            do {
                let decoder = JSONDecoder()
                let toDecodeSpots = try decoder.decode([DecodeSpot].self, from: data)
    
                for spot in toDecodeSpots {
                    spots.append(Spots(id: spot.id, name: spot.name, address: spot.address, creator: spot.creator_name, description: spot.description, rating: spot.rating, image: spot.image, link: spot.link, tags: spot.tags, mapInfo: Spots.MapInfo(logo: spot.logo, color: spot.color, longitude: spot.longitude, latitude: spot.latitude)))
                }

            } catch {
                print("Error loading data: \(error.localizedDescription)")
                
            }
        }.resume()
    }
}


#Preview {
    ContentView()
}
