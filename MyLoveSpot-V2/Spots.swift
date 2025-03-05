//
//  Spots.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import Foundation
import MapKit
import SwiftUI

struct Spots: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let location: String
    let description: String
    let mapInfo: MapInfo?

    struct MapInfo {
        let imageMarker: String
        let colorMarker: Color
        let coordinates: CLLocationCoordinate2D
    }
    
    init(title: String, location: String, description: String, mapInfo: MapInfo? = nil) {
        self.title = title
        self.location = location
        self.description = description
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
