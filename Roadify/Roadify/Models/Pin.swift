import Foundation
import CoreLocation
import SwiftUI
import UIKit

struct Pin: Identifiable {
    var id: String  // Firestore document ID
    var latitude: Double
    var longitude: Double
    var title: String
    var description: String
    var status: PinStatus
    var imageUrls: [String] = []  // Store URLs of uploaded images
    
    enum PinStatus: String {
        case pending = "Pending"
        case verified = "Verified"
    }
    
    // Firebase requires dictionaries to store data
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": description,
            "latitude": latitude,
            "longitude": longitude,
            "status": status.rawValue,
            "imageUrls": imageUrls  // URLs for the uploaded images
        ]
    }
    
    // Initialize Pin from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let description = data["description"] as? String,
              let latitude = data["latitude"] as? Double,
              let longitude = data["longitude"] as? Double,
              let statusString = data["status"] as? String,
              let status = PinStatus(rawValue: statusString),
              let imageUrls = data["imageUrls"] as? [String] else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.imageUrls = imageUrls
    }
    
    // Custom initializer for creating new pins
    init(id: String = UUID().uuidString, latitude: Double, longitude: Double, title: String, description: String, status: PinStatus, imageUrls: [String] = []) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.description = description
        self.status = status
        self.imageUrls = imageUrls
    }
}
