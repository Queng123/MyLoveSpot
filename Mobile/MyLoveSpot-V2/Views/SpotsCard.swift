//
//  SpotsCArd.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/10/25.
//

import SwiftUI
import MapKit

struct SpotCard: View {
    @Binding var spot: Spots
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
                
                    Image(systemName: spot.my_rating != -1 ? "star.fill" : "star")
                        .foregroundColor(spot.my_rating != -1 ? .yellow : .gray)
                    
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
                    
                    Image(systemName: spot.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(spot.isFavorite ? .red : .gray)
                    
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
