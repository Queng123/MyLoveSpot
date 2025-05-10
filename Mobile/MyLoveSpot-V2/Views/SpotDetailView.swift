//
//  SpotDetailView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/4/25.
//


import SwiftUI

struct SpotDetailView: View {
    @Binding var selectedSpot: Spots
    @ObservedObject var store: SpotsStore
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int = 0
    @State private var hasSubmitted = false
    @EnvironmentObject var authManager: AuthenticationManager
    @State var isFavorite: Bool = false

    var body: some View {
        VStack {
            Text(selectedSpot.name)
                .font(.title)
                .padding()
            
            Text(selectedSpot.description)
                .padding()

            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
            .padding()

            Button("Submit Rating") {
                submitRating()
                
            }
            .disabled(rating == 0 || hasSubmitted)
            .padding()
            .background(hasSubmitted ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            HStack {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.title)
                    .onTapGesture {
                        isFavorite.toggle()
                        storeFavorite(isFavorite: isFavorite)
                    }
            }
            .padding()


            Spacer()
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }.onAppear {
            if selectedSpot.my_rating != -1 {
                rating = selectedSpot.my_rating
                hasSubmitted = true
            }
            isFavorite = selectedSpot.isFavorite
            
        }
    }
    
    func submitRating() {
        guard let url = URL(string: "http://localhost:3000/rating/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authManager.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token: Not available")
        }
        let ratingData: [String: Any] = [
            "spot_id": selectedSpot.id,
            "rating": rating
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ratingData, options: [])
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting rating: \(error)")
                return
            }
            if response is HTTPURLResponse {
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let newRatingGlobal = jsonResponse["new_rating"] as? Double {
                                DispatchQueue.main.async {
                                    hasSubmitted = true
                                    updateSelectedSpotRating(to: rating, newRatingGlobal: newRatingGlobal)
                                }
                            } else {
                                print("New rating not found in the response")
                            }
                        }
                    } catch {
                        print("Error parsing response data: \(error)")
                    }
                }
            }
            
        }.resume()
    }
    
    func storeFavorite(isFavorite: Bool) {
        guard let url = URL(string: "http://localhost:3000/favorite/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authManager.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token: Not available")
        }
        let favoriteData: [String: Any] = [
            "spot_id": selectedSpot.id,
            "is_favorite": isFavorite
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: favoriteData, options: [])
            if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
                    print("Request Body: \(bodyString)")
                }
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting favorite: \(error)")
                return
            }
            if response is HTTPURLResponse {
                if let data = data {
                    do {
                        if try JSONSerialization.jsonObject(with: data, options: []) is [String: Any] {
                            DispatchQueue.main.async {
                                hasSubmitted = true
                                updateSelectedSpotFavorite(to: isFavorite)
                            }
                        }
                    } catch {
                        print("Error parsing response data: \(error)")
                    }
                }
            }
            
        }.resume()
    }
    func updateSelectedSpotRating(to newRating: Int, newRatingGlobal: Double) {
        if let index = store.spots.firstIndex(where: { $0.id == selectedSpot.id }) {
            DispatchQueue.main.async {
                store.spots[index].my_rating = newRating
                store.spots[index].rating = newRatingGlobal
                store.spots = store.spots
            }
        }
    }
    
    func updateSelectedSpotFavorite(to isFavorite: Bool) {
        if let index = store.spots.firstIndex(where: { $0.id == selectedSpot.id }) {
            DispatchQueue.main.async {
                store.spots[index].isFavorite = isFavorite
                store.spots = store.spots
            }
        }
    }
}
