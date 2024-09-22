/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date:
 Last modified: 22/9/24
 Acknowledgement:
 */

import CoreLocation
import FirebaseCore
import Foundation
import SwiftUI
import UIKit

struct Pin: Identifiable {
    var id: String  // Firestore document ID
    var latitude: Double
    var longitude: Double
    var title: String
    var description: String
    var status: PinStatus
    var imageUrls: [String] = []
    var timestamp: Date
    var reportedBy: String
    var likes: Int
    var dislikes: Int

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
            "timestamp": Timestamp(date: timestamp),
            "reportedBy": reportedBy,
            "likes": likes,
            "dislikes": dislikes,
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
            let dislikes = data["dislikes"] as? Int
        else {
            return nil
        }

        self.id = id
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.imageUrls = imageUrls
        self.timestamp = timestamp.dateValue()
        self.reportedBy = reportedBy
        self.likes = likes
        self.dislikes = dislikes
    }

    // Custom initializer for creating new pins
    init(
        id: String = UUID().uuidString, latitude: Double, longitude: Double, title: String,
        description: String, status: PinStatus, imageUrls: [String] = [], timestamp: Date,
        reportedBy: String, likes: Int = 0, dislikes: Int = 0
    ) {
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
