import Foundation

struct ActivityLog: Identifiable {
    var id: String
    var userId: String
    var action: String
    var timestamp: Date
    var metadata: [String: Any]?
}
