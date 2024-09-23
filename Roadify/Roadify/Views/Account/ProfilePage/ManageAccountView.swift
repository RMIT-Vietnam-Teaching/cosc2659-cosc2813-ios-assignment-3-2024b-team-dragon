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

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

struct ManageAccountDataView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AccountViewModel()
    @State private var showDeleteConfirmation = false
    @State private var deletionError: String?
    @State private var isDeleting = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    SettingsRow(
                        iconName: "trash",
                        label: NSLocalizedString(
                            "ManageAccount_deleteAccount", comment: "Delete Account"))
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text(
                            NSLocalizedString(
                                "alert_deleteTitle", comment: "Delete Account Alert Title")),
                        message: Text(
                            NSLocalizedString("ManageAccount_AreUSure", comment: "Delete Prompt")),
                        primaryButton: .destructive(
                            Text(
                                NSLocalizedString(
                                    "ManageAccount_deleteButton",
                                    comment: "Button to Delete in Alert"))
                        ) {
                            deleteAccount()
                        },
                        secondaryButton: .cancel()
                    )
                }

                if isDeleting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .padding()
                }

                if let deletionError = deletionError {
                    Text("Error: \(deletionError)")
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(
                NSLocalizedString("ManageAccount_title", comment: "Manage Account Data")
            )
            .onAppear {
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }

    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            deletionError = NSLocalizedString("ManageAccount_errorNoUser", comment: "No User Error")
            return
        }

        isDeleting = true

        let db = Firestore.firestore()

        // Delete user data from Firestore
        db.collection("users").document(user.uid).delete { error in
            if let error = error {
                deletionError =
                    NSLocalizedString("ManageAccount_FailtoDelete1", comment: "faile to delete")
                    + "\(error.localizedDescription)"
                isDeleting = false
                return
            }

            // Delete user from Firebase Authentication
            user.delete { error in
                if let error = error {
                    deletionError =
                        NSLocalizedString("ManageAccount_FailtoDelete2", comment: "fail to delete")
                        + "\(error.localizedDescription)"
                } else {
                    // Successfully deleted account, handle sign-out and delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        viewModel.logOut()
                        isDeleting = false 
                    }
                }
            }
        }
    }
}
