import Foundation
import CoreLocation
import SwiftUI
import UIKit
import FirebaseCore

struct Pin: Identifiable {
    var id: String  // Firestore document ID
    var latitude: Double
    var longitude: Double
    var title: String
    var description: String
    var status: PinStatus
    var imageUrls: [String] = []  // Store URLs of uploaded images
    var timestamp: Date  // Timestamp when the pin was placed
    var reportedBy: String  // ID of the user who reported the pin
    var likes: Int  // Number of likes
    var dislikes: Int  // Number of dislikes

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
            "imageUrls": imageUrls,
            "timestamp": Timestamp(date: timestamp),  // Save as Firestore Timestamp
            "reportedBy": reportedBy,  // Save the user ID
            "likes": likes,
            "dislikes": dislikes
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
              let imageUrls = data["imageUrls"] as? [String],
              let timestamp = data["timestamp"] as? Timestamp,
              let reportedBy = data["reportedBy"] as? String,
              let likes = data["likes"] as? Int,
              let dislikes = data["dislikes"] as? Int else {
            return nil
        }

        self.id = id
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.imageUrls = imageUrls
        self.timestamp = timestamp.dateValue()  // Convert Firestore Timestamp to Date
        self.reportedBy = reportedBy
        self.likes = likes
        self.dislikes = dislikes
    }

    // Custom initializer for creating new pins
    init(id: String = UUID().uuidString, latitude: Double, longitude: Double, title: String, description: String, status: PinStatus, imageUrls: [String] = [], timestamp: Date, reportedBy: String, likes: Int = 0, dislikes: Int = 0) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.description = description
        self.status = status
        self.imageUrls = imageUrls
        self.timestamp = timestamp
        self.reportedBy = reportedBy
        self.likes = likes
        self.dislikes = dislikes
    }
}
