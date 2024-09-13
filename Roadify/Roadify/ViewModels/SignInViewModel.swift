import SwiftUI
import FirebaseAuth

class SignInViewModel: ObservableObject {
    @Published var loginCredentials = LoginCredentials(email: "", password: "")
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn = false

    func login() {
        Auth.auth().signIn(withEmail: loginCredentials.email, password: loginCredentials.password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoggedIn = false
            } else {
                self?.isLoggedIn = true
            }
        }
    }
}
