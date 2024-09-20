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
    
    // Initializer
    init(id: String, username: String, firstName: String, lastName: String, email: String, createdAt: Date, isAdmin: Bool) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = createdAt
        self.isAdmin = isAdmin  // Initialize admin status
    }
    
    // Convenience initializer to create a User object from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let username = data["username"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let timestamp = data["createdAt"] as? Timestamp,
              let isAdmin = data["isAdmin"] as? Bool else {  // Ensure admin status is retrieved
            return nil
        }
        
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = timestamp.dateValue()
        self.isAdmin = isAdmin  // Assign admin status
    }
    
    // Method to convert the User model to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": Timestamp(date: createdAt),
            "isAdmin": isAdmin  // Include admin status in the dictionary
        ]
    }
}
