/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

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
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    func refreshAuthStatus() {
        checkUserAuthentication()
    }
}
