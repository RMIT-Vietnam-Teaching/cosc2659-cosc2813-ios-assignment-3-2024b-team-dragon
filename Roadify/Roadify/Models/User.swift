import Foundation
import FirebaseFirestore

struct User: Identifiable {
    var id: String  // The user's Firebase UID
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var createdAt: Date
    
    // Initializer
    init(id: String, username: String, firstName: String, lastName: String, email: String, createdAt: Date) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = createdAt
    }
    
    // Convenience initializer to create a User object from Firestore data
    init?(id: String, data: [String: Any]) {
        guard let username = data["username"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let timestamp = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = timestamp.dateValue()
    }
    
    // Method to convert the User model to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
