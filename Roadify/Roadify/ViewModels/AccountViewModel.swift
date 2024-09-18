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
    
    init() {
        fetchUserData()
    }
    
    // Fetch user data from Firestore
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            self.email = user.email ?? "No Email"
            
            let userRef = db.collection("users").document(user.uid)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.username = document.data()?["username"] as? String ?? "No Username"
                    self.profileImageUrl = document.data()?["profileImageUrl"] as? String ?? ""
                    self.address = document.data()?["address"] as? String ?? ""
                    self.mobilePhone = document.data()?["mobilePhone"] as? String ?? ""
                } else {
                    self.username = "No Username"
                }
            }
        } else {
            self.username = "Guest"
            self.email = "Not logged in"
        }
    }
    
    // Save the updated profile to Firestore and Firebase Storage
    func saveProfile(username: String, address: String, mobilePhone: String, profileImage: UIImage?) {
        if let user = Auth.auth().currentUser {
            let userRef = db.collection("users").document(user.uid)
            
            // Save profile image if it was updated
            if let image = profileImage {
                uploadProfileImage(image: image) { [weak self] url in
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
                    self.firebaseService.logActivity(action: "Profile Updated", metadata: ["username": username])
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
                self.firebaseService.logActivity(action: "Profile Updated", metadata: ["username": username])

            }
        }
    }
    
    // Function to upload profile image to Firebase Storage
    private func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        let storageRef = storage.reference().child("profile_images/\(user.uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image URL: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString)
                }
            }
        }
    }
    // Log out the user
    func logOut() {
        do {
            try Auth.auth().signOut()
            // Reset published variables after logout
            self.username = "Guest"
            self.email = "Not logged in"
            self.address = ""
            self.mobilePhone = ""
            self.profileImageUrl = ""
            
            // Log the logout activity
            self.firebaseService.logActivity(action: "User Logged Out")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
