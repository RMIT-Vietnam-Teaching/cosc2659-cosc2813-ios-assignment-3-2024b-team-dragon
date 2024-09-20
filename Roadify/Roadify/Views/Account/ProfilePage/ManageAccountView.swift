//
//  ManageAccountView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

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
                    settingsRow(
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()  // Dismiss the sheet when the "X" is tapped
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private func settingsRow(iconName: String, label: String) -> some View {
        HStack {
            Image(systemName: iconName)
            Text(label)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
    }

    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            deletionError = NSLocalizedString("ManageAccount_errorNoUser", comment: "No User Error")
            return
        }

        isDeleting = true  // Show progress indicator

        // Initialize Firestore
        let db = Firestore.firestore()

        // Delete user data from Firestore
        db.collection("users").document(user.uid).delete { error in
            if let error = error {
                deletionError =
                    NSLocalizedString("ManageAccount_FailtoDelete1", comment: "faile to delete")
                    + "\(error.localizedDescription)"
                isDeleting = false  // Hide progress indicator
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
                        isDeleting = false  // Hide progress indicator
                    }
                }
            }
        }
    }
}
