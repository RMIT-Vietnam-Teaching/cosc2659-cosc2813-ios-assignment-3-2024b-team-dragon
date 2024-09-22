//
//  NotificationItem.swift
//  Roadify
//
//  Created by Lê Phước on 22/9/24.
//
import Foundation
import FirebaseCore

struct NotificationItem: Identifiable {
    var id: String
    var title: String
    var body: String
    var timestamp: Date
    var read: Bool
    
    // Initialize from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let body = data["body"] as? String,
              let timestamp = data["timestamp"] as? Timestamp,
              let read = data["read"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.body = body
        self.timestamp = timestamp.dateValue()
        self.read = read
    }
}
