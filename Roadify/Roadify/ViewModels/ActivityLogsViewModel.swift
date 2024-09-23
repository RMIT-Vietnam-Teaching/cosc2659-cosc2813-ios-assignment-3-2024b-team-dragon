/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class ActivityLogsViewModel: ObservableObject {
    @Published var activityLogs: [ActivityLog] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchActivityLogs()
    }
    
    func fetchActivityLogs() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = NSLocalizedString("activityLogs_error_notLoggedIn", comment: "User not logged in error")
            return
        }
        
        self.isLoading = true
        db.collection("activityLogs")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        self.errorMessage = NSLocalizedString("activityLogs_error_noLogsFound", comment: "No activity logs found error")
                        return
                    }
                    
                    self.activityLogs = documents.compactMap { doc in
                        let data = doc.data()
                        guard let userId = data["userId"] as? String,
                              let action = data["action"] as? String,
                              let timestamp = data["timestamp"] as? Timestamp else {
                            return nil
                        }
                        return ActivityLog(id: doc.documentID, userId: userId, action: action, timestamp: timestamp.dateValue(), metadata: data["metadata"] as? [String: Any])
                    }
                }
            }
    }
    
    // Function to add a new activity log
    func addActivityLog(action: String, metadata: [String: Any]? = nil) {
        guard let user = Auth.auth().currentUser else { return }
        
        let newLog: [String: Any] = [
            "userId": user.uid,
            "action": action,
            "timestamp": Timestamp(date: Date()),
            "metadata": metadata ?? [:]
        ]
        
        db.collection("activityLogs").addDocument(data: newLog) { error in
            if let error = error {
                print(NSLocalizedString("activityLogs_error_addingLog", comment: "Error adding activity log") + ": \(error.localizedDescription)")
            }
        }
    }
}
