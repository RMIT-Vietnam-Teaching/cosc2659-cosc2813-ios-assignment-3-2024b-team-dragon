import Foundation
import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkUserAuthentication()
    }
    
    private func checkUserAuthentication() {
        if Auth.auth().currentUser != nil {
            // User is signed in
            self.isLoggedIn = true
        } else {
            // No user is signed in
            self.isLoggedIn = false
        }
    }
    
    func refreshAuthStatus() {
        checkUserAuthentication()
    }
}
