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
        VStack(spacing: 20) {
            HStack {
                Text(selectedSpot.name)
                    .font(.largeTitle.bold())
                    .padding(.top)
                Button(action: {
                    isFavorite.toggle()
                    storeFavorite(isFavorite: isFavorite)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 36))
                        .foregroundColor(.red)
                }
                .padding(.top)
            }
        
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(.gray.opacity(0.6))
            
            Text(selectedSpot.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(selectedSpot.address)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            if let url = selectedSpot.link {
                Button(action: {
                    UIApplication.shared.open(url)
                }) {
                    Text("More infos")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }


            
            Divider()
            
            VStack(spacing: 10) {
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title)
                            .onTapGesture {
                                rating = index
                            }
                    }
                    Text(String(format: "%.1f", selectedSpot.rating))
                        .font(.title2)
                        .padding(.leading, 8)
                }
                
                Button(action: submitRating) {
                    Text("Submit Rating")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(hasSubmitted ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(rating == 0 || hasSubmitted)
                .padding(.horizontal)
            }

            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(selectedSpot.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }

            HStack(spacing: 4) {
                Text("Added with love by")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(selectedSpot.creator)
                    .font(.caption.bold())
                    .foregroundColor(.gray)
            }

            Spacer()

            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue)
            .padding(.bottom)
        }
        .padding()
        .onAppear {
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
