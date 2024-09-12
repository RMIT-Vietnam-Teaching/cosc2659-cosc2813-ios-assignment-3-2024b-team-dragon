//
//  PinModel.swift
//  Roadify
//
//  Created by Lê Phước on 12/9/24.
//

import Foundation
import CoreLocation
import SwiftUI

struct PinModel: Identifiable {
    var id = UUID().uuidString
    var latitude: Double
    var longitude: Double
    var status: PinStatus
    var title: String
    var description: String?
    var images: [UIImage] = []  // Add images array
    
    enum PinStatus: String {
        case pending = "Pending"
        case verified = "Verified"
    }
    
    // Helper function to return the pin's coordinate
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
