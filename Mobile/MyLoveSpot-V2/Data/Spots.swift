//
//  Spots.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import Foundation
import MapKit
import SwiftUI

struct Spots: Hashable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let creator: String
    let description: String
    let rating: Double
    let image: URL?
    let link: URL?
    let tags: [String]
    var my_rating: Int
    let mapInfo: MapInfo?

    struct MapInfo {
        let logo: String
        let color: Color
        let coordinates: CLLocationCoordinate2D
        
        init(logo:String, color: String, longitude: String, latitude: String) {
            self.logo = logo
            self.coordinates = CLLocationCoordinate2D(
                latitude: Double(latitude) ?? 0.0,
                longitude: Double(longitude) ?? 0.0
                )
            self.color = Color(hex: color) ?? .black
        }
    }
    
    init(id:Int, name: String, address: String, creator: String, description: String, rating: String, image: String, link: String, tags: [String], my_rating: Int, mapInfo: MapInfo?) {
        self.id = id
        self.name = name
        self.address = address
        self.creator = creator
        self.description = description
        self.rating = Double(rating) ?? 0.0
        self.image = URL(string: image)
        self.link = URL(string: link)
        self.tags = tags
        self.my_rating = my_rating
        self.mapInfo = mapInfo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Spots: Equatable {
    static func == (lhs: Spots, rhs: Spots) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Color {
    init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        guard hexFormatted.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct DecodeSpot: Codable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let longitude: String
    let latitude: String
    let logo: String
    let rating: String
    let color: String
    let image: String
    let link: String
    let created_at: String
    let updated_at: String
    let creator_name: String
    let tags: [String]
    let my_rating: Int
}
