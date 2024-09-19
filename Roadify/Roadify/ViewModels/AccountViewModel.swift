import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var profileImageUrl: String = ""
    @Published var address: String = ""
    @Published var mobilePhone: String = ""
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    private var firebaseService = FirebaseService()
    private var userService = UserService()
    
    init() {
        fetchUserData()
    }
    
    // Fetch user data from Firestore
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            self.email = user.email ?? NSLocalizedString("no_email", comment: "No email available")
            
            let userRef = db.collection("users").document(user.uid)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.username = document.data()?["username"] as? String ?? NSLocalizedString("no_username", comment: "No username available")
                    self.profileImageUrl = document.data()?["profileImageUrl"] as? String ?? ""
                    self.address = document.data()?["address"] as? String ?? ""
                    self.mobilePhone = document.data()?["mobilePhone"] as? String ?? ""
                } else {
                    self.username = NSLocalizedString("no_username", comment: "No username available")
                }
            }
        } else {
            self.username = NSLocalizedString("guest", comment: "Guest user")
            self.email = NSLocalizedString("not_logged_in", comment: "User not logged in")
        }
    }
    
    // Save the updated profile to Firestore and Firebase Storage
    func saveProfile(username: String, address: String, mobilePhone: String, profileImage: UIImage?) {
        if let user = Auth.auth().currentUser {
            let userRef = db.collection("users").document(user.uid)
            
            // Save profile image if it was updated
            if let image = profileImage {
                userService.uploadProfileImage(image: image) { [weak self] url in
                    guard let self = self else { return }
                    guard let imageUrl = url else { return }
                    
                    // Update Firestore with the image URL
                    userRef.setData([
                        "username": username,
                        "address": address,
                        "mobilePhone": mobilePhone,
                        "profileImageUrl": imageUrl
                    ], merge: true)
                    
                    // Update local variables
                    self.username = username
                    self.address = address
                    self.mobilePhone = mobilePhone
                    self.profileImageUrl = imageUrl
                    
                    // Log the profile update activity
                    self.firebaseService.logActivity(action: NSLocalizedString("profile_updated", comment: "Profile updated"), metadata: ["username": username])
                }
            } else {
                // If no image was updated, just update the other details
                userRef.setData([
                    "username": username,
                    "address": address,
                    "mobilePhone": mobilePhone
                ], merge: true)
                
                // Update local variables
                self.username = username
                self.address = address
                self.mobilePhone = mobilePhone
                
                // Log the profile update activity
                self.firebaseService.logActivity(action: NSLocalizedString("profile_updated", comment: "Profile updated"), metadata: ["username": username])
            }
        }
    }
    
    
    // Log out the user
    func logOut() {
        do {
            try Auth.auth().signOut()
            // Reset published variables after logout
            self.username = NSLocalizedString("guest", comment: "Guest user")
            self.email = NSLocalizedString("not_logged_in", comment: "User not logged in")
            self.address = ""
            self.mobilePhone = ""
            self.profileImageUrl = ""
            
            // Log the logout activity
            self.firebaseService.logActivity(action: NSLocalizedString("user_logged_out", comment: "User logged out"))
        } catch let error {
            print(NSLocalizedString("error_signing_out", comment: "Error signing out") + ": \(error.localizedDescription)")
        }
    }
}
