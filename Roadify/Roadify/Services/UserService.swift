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
import UIKit

// Function to upload profile image to Firebase Storage
class UserService: ImageUploadService {
    func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        let profileImagePath = "profile_images/\(user.uid).jpg"
        uploadImage(image: image, path: profileImagePath, completion: completion)
    }
}
