//
//  SignUpViewModel.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import FirebaseAuth
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var username: String = "" {
        didSet { validateUsername() }
    }
    @Published var firstName: String = "" {
        didSet { validateFirstName() }
    }
    @Published var lastName: String = "" {
        didSet { validateLastName() }
    }
    @Published var email: String = "" {
        didSet { validateEmail() }
    }
    @Published var password: String = "" {
        didSet { validatePassword() }
    }

    @Published var repeatPassword: String = "" {
        didSet { validateRepeatPassword() }
    }

    @Published var isUsernameValid: Bool? = nil
    @Published var isFirstNameValid: Bool? = nil
    @Published var isLastNameValid: Bool? = nil
    @Published var isEmailValid: Bool? = nil
    @Published var isPasswordValid: Bool? = nil
    @Published var isRepeatPasswordValid: Bool? = nil

    @Published var isOTPVerified = false
    @Published var isRegistered = false
    @Published var errorMessage: String? = nil

    private let firebaseService = FirebaseService()  // Use the FirebaseService instance

    private func validateUsername() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isUsernameValid = !self.username.isEmpty
        }
    }

    private func validateFirstName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isFirstNameValid = !self.firstName.isEmpty
        }
    }

    private func validateLastName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLastNameValid = !self.lastName.isEmpty
        }
    }

    private func validateEmail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isEmailValid = self.isValidEmail(self.email)
        }
    }

    private func validatePassword() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isPasswordValid = self.password.count >= 6
        }
    }

    private func validateRepeatPassword() {
        if password == repeatPassword {
            isRepeatPasswordValid = true
            errorMessage = nil
        } else {
            isRepeatPasswordValid = false
            errorMessage = "Repeat password should be similar to password"
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func signUpWithEmailPassword() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            if let userID = Auth.auth().currentUser?.uid {
                _ = User(
                    id: userID,
                    username: self?.username ?? "",
                    firstName: self?.firstName ?? "",
                    lastName: self?.lastName ?? "",
                    email: self?.email ?? "",
                    createdAt: Date()
                )
                //                self?.firebaseService.saveUser(user: user) { error in
                //                    if let error = error {
                //                        self?.errorMessage = "Failed to save user details: \(error.localizedDescription)"
                //                    } else {
                //                        self?.isRegistered = true
                //                    }
                //                }
            }

            self?.sendEmailVerification()
        }
    }

    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            self?.isRegistered = true
        })
    }

    func checkEmailVerification() {
        Auth.auth().currentUser?.reload(completion: { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            if Auth.auth().currentUser?.isEmailVerified == true {
                self?.isOTPVerified = true
                self?.errorMessage = nil  // Clear error message if email is verified
            } else {
                self?.errorMessage = "Email is not verified yet. Please check your inbox."
            }
        })
    }
}
