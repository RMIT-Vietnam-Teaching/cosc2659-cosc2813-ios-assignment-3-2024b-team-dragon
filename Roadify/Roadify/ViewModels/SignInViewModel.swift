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
                self?.errorMessage = NSLocalizedString("signIn_error_loginFailed", comment: "Error: Login failed") + ": \(error.localizedDescription)"
                self?.isLoggedIn = false
            } else {
                self?.isLoggedIn = true
                // Log the login activity
                self?.firebaseService.logActivity(action: NSLocalizedString("signIn_action_loggedIn", comment: "User logged in"))
            }
        }
    }
}
