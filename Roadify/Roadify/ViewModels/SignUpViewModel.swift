import SwiftUI
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isOTPVerified = false
    @Published var isRegistered = false
    @Published var errorMessage: String? = nil
    
    private let firebaseService = FirebaseService()  // Use the FirebaseService instance

    // Sign up user using email and password
    func signUpWithEmailPassword() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            // After successful registration, save user details in Firestore
            if let userID = Auth.auth().currentUser?.uid {
                let user = User(
                    id: userID,
                    username: self?.username ?? "",
                    firstName: self?.firstName ?? "",
                    lastName: self?.lastName ?? "",
                    email: self?.email ?? "",
                    createdAt: Date()
                )
                self?.firebaseService.saveUser(user: user) { error in
                    if let error = error {
                        self?.errorMessage = "Failed to save user details: \(error.localizedDescription)"
                    } else {
                        self?.isRegistered = true
                    }
                }
            }
            
            // Send email verification
            self?.sendEmailVerification()
        }
    }

    // Send email verification OTP
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            // Email verification sent successfully
            self?.isRegistered = true
        })
    }
    
    // Function to check email verification
    func checkEmailVerification() {
        Auth.auth().currentUser?.reload(completion: { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            if Auth.auth().currentUser?.isEmailVerified == true {
                // Email is verified
                self?.isOTPVerified = true
            } else {
                self?.errorMessage = "Email not verified yet. Please check your inbox."
            }
        })
    }
}
