//
//  UserManagementViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class UserManagementViewModel: ObservableObject {
    @Published var users: [User] = []
    private var db = Firestore.firestore()

    init() {
        fetchNonAdminUsers()
    }

    // Fetch users who are not admins
    func fetchNonAdminUsers() {
        db.collection("users")
            .whereField("isAdmin", isEqualTo: false)  // Fetch users where isAdmin is false
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }

                self.users = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    return User(id: document.documentID, data: data)
                } ?? []
            }
    }

    // Approve user (example action, could be modifying user roles or data)
    func approveUser(_ user: User) {
        db.collection("users").document(user.id).updateData([
            "isApproved": true  // Example field you could update
        ]) { error in
            if let error = error {
                print("Error approving user: \(error.localizedDescription)")
            } else {
                print("User approved successfully!")
            }
        }
    }

    // Reject or delete user
    func rejectUser(_ user: User) {
        db.collection("users").document(user.id).delete { error in
            if let error = error {
                print("Error rejecting user: \(error.localizedDescription)")
            } else {
                print("User rejected and deleted successfully!")
            }
        }
    }
}
