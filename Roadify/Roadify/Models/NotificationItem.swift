/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 22/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

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
