//
//  NotificationsViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 22/9/24.
//

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
                            notificationSet.insert(notification.id)  // Mark this notification as seen
                            return notification  // Return unique notification
                        }
                    } else {
                        return nil
                    }
                } ?? []
            }
    }
}
