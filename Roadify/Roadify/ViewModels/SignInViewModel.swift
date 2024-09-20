//
//  SignInViewModel.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import SwiftUI
import FirebaseAuth


class SignInViewModel: ObservableObject {
    @StateObject private var authManager = AuthManager()
    @Published var loginCredentials = LoginCredentials(email: "", password: "")
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn = false

    private var firebaseService = FirebaseService() // Reference to FirebaseService

    func login() {
        Auth.auth().signIn(withEmail: loginCredentials.email, password: loginCredentials.password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoggedIn = false
            } else {
                self?.isLoggedIn = true
                // Log the login activity
                self?.firebaseService.logActivity(action: "User Logged In")
            }
        }
    }
}
