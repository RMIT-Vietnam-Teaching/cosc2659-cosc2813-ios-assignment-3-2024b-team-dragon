/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import FirebaseFirestore

struct User: Identifiable {
    var id: String  
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var createdAt: Date
    var isAdmin: Bool
    
    init(id: String, username: String, firstName: String, lastName: String, email: String, createdAt: Date, isAdmin: Bool) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = createdAt
        self.isAdmin = isAdmin
    }
    
    // Convenience initializer to create a User object from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let username = data["username"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let timestamp = data["createdAt"] as? Timestamp,
              let isAdmin = data["isAdmin"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = timestamp.dateValue()
        self.isAdmin = isAdmin
    }
    
    // Method to convert the User model to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": Timestamp(date: createdAt),
            "isAdmin": isAdmin 
        ]
    }
}
