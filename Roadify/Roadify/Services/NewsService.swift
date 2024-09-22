/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement:
 */

import Foundation
import UIKit

class NewsService: FirebaseService {
    // Fetch News
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

    // Add News with Image Upload
    func addNews(news: News, image: UIImage, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")  // Using inherited 'storage' property
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(NSError(domain: "ImageError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Image could not be processed"]))
            return
        }

        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
                return
            }

            // Retrieve image download URL
            storageRef.downloadURL { (url, error) in
                if let url = url {
                    var updatedNews = news
                    updatedNews.imageName = url.absoluteString  // Store image URL in model
                    
                    // Save news to Firestore
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
