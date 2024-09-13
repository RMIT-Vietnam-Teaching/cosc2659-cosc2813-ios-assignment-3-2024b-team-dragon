import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

class FirebaseService: NSObject, ObservableObject {
    private var db = Firestore.firestore()
    
    // MARK: - Create DEMO
    func addMarker(title: String, coordinate: CLLocationCoordinate2D, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("markers").document() // Automatically generate a document ID
        let newMarker = Marker(id: ref.documentID, title: title, coordinate: coordinate) // Create a new marker with the generated ID
        ref.setData(newMarker.toDictionary()) { error in
            completion(error)
        }
    }
    
    // MARK: - Read DEMO
    func fetchMarkers(completion: @escaping (Result<[Marker], Error>) -> Void) {
        db.collection("markers").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var markers: [Marker] = []
            for document in querySnapshot?.documents ?? [] {
                let marker = Marker(id: document.documentID, data: document.data())
                markers.append(marker)
            }
            completion(.success(markers))
        }
    }
    
    // MARK: - Update DEMO
    func updateMarker(marker: Marker, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("markers").document(marker.id)
        ref.setData(marker.toDictionary()) { error in
            completion(error)
        }
    }
    
    // MARK: - Delete DEMO
    func deleteMarker(markerId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("markers").document(markerId)
        ref.delete { error in
            completion(error)
        }
    }
    
    // MARK: - Save User Details to Firestore using User model
    func saveUser(user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).setData(user.toDictionary()) { error in
            completion(error)
        }
    }

    // MARK: - Fetch User Details from Firestore using User model
    func fetchUser(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        let ref = db.collection("users").document(userID)
        ref.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let data = document.data() {
                if let user = User(id: userID, data: data) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    // MARK: - Upload Photo to Firebase Storage and Firestore
    func uploadPhoto(selectedImage: UIImage, title: String, description: String, completion: @escaping (Error?) -> Void) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Could not convert image to data")
            return
        }

        let storageRef = Storage.storage().reference()
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)

        // Upload the image data
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(error)
                return
            }

            // Get the download URL
            fileRef.downloadURL { url, error in
                guard let url = url, error == nil else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(error)
                    return
                }

                let urlString = url.absoluteString
                print("Download URL: \(urlString)")

                // Save to Firestore
                let newsItem = News(id: UUID().uuidString, title: title, image: urlString, description: description)
                self.db.collection("news").document(newsItem.id).setData(newsItem.toDictionary()) { error in
                    completion(error)
                }
            }
        }
    }
}
