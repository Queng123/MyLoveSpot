//
//  SpotDetailView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/4/25.
//


import SwiftUI

struct SpotDetailView: View {
    // Todo get selected spot and update it, fromt he previous view
    @Binding var spot: Spots
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int = 0
    @State private var hasSubmitted = false

    var body: some View {
        VStack {
            Text(spot.name)
                .font(.title)
                .padding()
            
            Text(spot.description)
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

            Spacer()
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }.onAppear {
            if spot.my_rating != -1 {
                rating = spot.my_rating
                hasSubmitted = true
            }
            
        }
    }
    
    func submitRating() {
        guard let url = URL(string: "http://localhost:3000/rating/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: Replace with actual token save in storage
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJxdWVudGluLmJyZWpvaW5AZ21haWwuY29tIiwiaWF0IjoxNzQ2Mzc5NTg3LCJleHAiOjE3NDYzODMxODd9.pdZxnLJEgjBNZwovhnn1F508zSDkxdu-TmCxM9cTQeY", forHTTPHeaderField: "Authorization")

        let ratingData: [String: Any] = [
            "spot_id": spot.id,
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
            if let response = response as? HTTPURLResponse {
                print("Rating submitted. Status code: \(response.statusCode)")
                DispatchQueue.main.async {
                    hasSubmitted = true
                }
            }
            spot.my_rating = rating
        }.resume()
    }
}
