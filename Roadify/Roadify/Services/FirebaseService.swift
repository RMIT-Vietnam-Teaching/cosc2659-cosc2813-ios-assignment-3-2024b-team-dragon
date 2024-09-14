import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

class FirebaseService: ObservableObject {
    private var db = Firestore.firestore()  // Access Firestore through Firebase
    private let storage = Storage.storage()
    
    // MARK: - Add Pin
    func addPin(pin: Pin, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pin.id)  // Use the Pin's ID as the document ID
        ref.setData(pin.toDictionary()) { error in
            completion(error)
        }
    }

    // MARK: - Fetch Pins
    func fetchPins(completion: @escaping (Result<[Pin], Error>) -> Void) {
        db.collection("pins").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var pins: [Pin] = []
            for document in querySnapshot?.documents ?? [] {
                let data = document.data()  // No need for optional binding, it's non-optional
                if let pin = Pin(id: document.documentID, data: data) {  // Handle optional Pin initialization
                    pins.append(pin)
                } else {
                    print("Error initializing Pin with documentID: \(document.documentID)")
                }
            }
            completion(.success(pins))
        }
    }

    // MARK: - Update Pin
    func updatePin(pin: Pin, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pin.id)
        ref.setData(pin.toDictionary()) { error in
            completion(error)
        }
    }

    // MARK: - Delete Pin
    func deletePin(pinId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pinId)
        ref.delete { error in
            completion(error)
        }
    }
    
    // MARK: - Upload Images to Firebase Storage
    func uploadImages(images: [UIImage], completion: @escaping ([String]) -> Void) {
        var uploadedImageURLs: [String] = []
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            
            let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                dispatchGroup.leave()
                continue
            }
            
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting image URL: \(error.localizedDescription)")
                    } else if let url = url {
                        uploadedImageURLs.append(url.absoluteString)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(uploadedImageURLs)
        }
    }
    
    // Fetch News from Firebase
    func fetchNews(completion: @escaping (Result<[News], Error>) -> Void) {
        db.collection("news").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var newsArticles: [News] = []
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    if let news = News(id: document.documentID, data: data) {
                        newsArticles.append(news)
                    }
                }
                completion(.success(newsArticles))
            }
        }
    }

    // Add News with Image Upload to Firebase
    func addNews(news: News, image: UIImage, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(NSError(domain: "ImageError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Image could not be processed"]))
            return
        }

        // Upload the image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // Once the image is uploaded, retrieve the download URL
            storageRef.downloadURL { (url, error) in
                if let url = url {
                    var updatedNews = news
                    updatedNews.imageName = url.absoluteString // Store image URL in the model

                    // Save the news to Firestore
                    let ref = self.db.collection("news").document(news.id)
                    ref.setData(updatedNews.toDictionary()) { error in
                        completion(error)
                    }
                } else {
                    completion(error)
                }
            }
        }
    }
}
