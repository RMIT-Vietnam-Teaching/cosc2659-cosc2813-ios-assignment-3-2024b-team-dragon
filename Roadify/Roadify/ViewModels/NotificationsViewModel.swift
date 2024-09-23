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
import FirebaseAuth
import FirebaseFirestore

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    private var db = Firestore.firestore()
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching notifications: \(error.localizedDescription)")
                    return
                }

                // Use Set to track unique notification IDs
                var notificationSet = Set<String>()

                self.notifications = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    
                    if let notification = NotificationItem(id: document.documentID, data: data) {
                        // Add logic to avoid duplicates by checking unique identifier (id)
                        if notificationSet.contains(notification.id) {
                            return nil  // Skip duplicate notification
                        } else {
                            notificationSet.insert(notification.id) 
                            return notification
                        }
                    } else {
                        return nil
                    }
                } ?? []
            }
    }
}
