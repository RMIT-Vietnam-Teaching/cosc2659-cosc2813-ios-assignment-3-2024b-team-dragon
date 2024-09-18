import Foundation

struct ActivityLog: Identifiable {
    var id: String // Use a unique identifier, e.g., Firestore document ID
    var userId: String
    var action: String
    var timestamp: Date
    var metadata: [String: Any]? // Optional: Additional details about the action
}
