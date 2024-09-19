//
//  ManageAccountView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ManageAccountDataView: View {
	@StateObject private var viewModel = AccountViewModel()
	@State private var showDeleteConfirmation = false
	@State private var deletionError: String?
	@State private var isDeleting = false
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Manage Account Data")
				.font(.title2)
				.bold()
			
			Button(action: {
				showDeleteConfirmation = true
			}) {
				settingsRow(iconName: "trash", label: "Delete Account")
			}
			.alert(isPresented: $showDeleteConfirmation) {
				Alert(
					title: Text("Delete Account"),
					message: Text("Are you sure you want to delete your account? This action cannot be undone."),
					primaryButton: .destructive(Text("Delete")) {
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
		.padding()
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
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
			deletionError = "No user is currently logged in."
			return
		}
		
		isDeleting = true // Show progress indicator
		
		// Initialize Firestore
		let db = Firestore.firestore()
		
		// Delete user data from Firestore
		db.collection("users").document(user.uid).delete { error in
			if let error = error {
				deletionError = "Failed to delete user data from Firestore: \(error.localizedDescription)"
				isDeleting = false // Hide progress indicator
				return
			}
			
			// Delete user from Firebase Authentication
			user.delete { error in
				if let error = error {
					deletionError = "Failed to delete account: \(error.localizedDescription)"
				} else {
					// Successfully deleted account, handle sign-out and delay
					DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
						viewModel.logOut()
						isDeleting = false // Hide progress indicator
					}
				}
			}
		}
	}
}

struct ManageAccountDataView_Previews: PreviewProvider {
	static var previews: some View {
		ManageAccountDataView()
	}
}
