import Foundation
import UIKit
/*
class ImageUploadService: FirebaseService {
    
    func uploadImages(images: [UIImage], completion: @escaping ([String]) -> Void) {
        var uploadedImageURLs: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            dispatchGroup.enter()
            let imageID = UUID().uuidString
            let storageRef = storage.reference().child("images/\(imageID).jpg")  // Using inherited 'storage' property
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if let url = url {
                            uploadedImageURLs.append(url.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
            } else {
                print("Error: Could not convert UIImage to JPEG data.")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(uploadedImageURLs)
        }
    }
}
*/
