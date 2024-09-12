//
//  PinModel.swift
//  Roadify
//
//  Created by Lê Phước on 12/9/24.
//

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
    var images: [UIImage] = []  // We will store image URLs instead of the images themselves in Firestore

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
            "imageURLs": [] // Replace this with an array of image URLs (Firebase Storage can be used for this)
        ]
    }
    
    // Initialize PinModel from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let description = data["description"] as? String,
              let latitude = data["latitude"] as? Double,
              let longitude = data["longitude"] as? Double,
              let statusString = data["status"] as? String,
              let status = PinStatus(rawValue: statusString),
              let imageURLs = data["imageURLs"] as? [String] else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        // Here you can fetch the actual images from Firebase Storage using the URLs
        self.images = []  // This would be the array of images fetched from URLs
    }
    
    // Custom initializer for creating new pins
    init(id: String = UUID().uuidString, latitude: Double, longitude: Double, title: String, description: String, status: PinStatus, images: [UIImage] = []) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.description = description
        self.status = status
        self.images = images
    }
}
