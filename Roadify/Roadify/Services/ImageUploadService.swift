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
import FirebaseStorage
import UIKit

class ImageUploadService: FirebaseService {
    
    // MARK: - Upload a Single Image
    func uploadImage(image: UIImage, path: String, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference().child(path)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print(NSLocalizedString("error_image_conversion", comment: "Error converting image to data"))
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                print(NSLocalizedString("error_uploading_image", comment: "Error uploading image") + ": \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(NSLocalizedString("error_getting_image_url", comment: "Error getting image URL") + ": \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString)
                }
            }
        }
    }
    
    // Existing method to upload multiple images
    func uploadImages(images: [UIImage], completion: @escaping ([String]) -> Void) {
        var uploadedImageURLs: [String] = []
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            let imageID = UUID().uuidString
            let path = "images/\(imageID).jpg"

            uploadImage(image: image, path: path) { url in
                if let url = url {
                    uploadedImageURLs.append(url)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("All images uploaded. Image URLs: \(uploadedImageURLs)")
            completion(uploadedImageURLs)
        }
    }
}

