//
//  UserService.swift
//  Roadify
//
//  Created by Cường Võ Duy on 18/9/24.
//

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
