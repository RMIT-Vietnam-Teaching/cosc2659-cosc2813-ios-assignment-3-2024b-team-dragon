import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

class FirebaseService: NSObject, ObservableObject {
	private var db = Firestore.firestore()
	private let storage = Storage.storage()
	
	// MARK: - Add Pin
	func addPin(pin: Pin, completion: @escaping (Error?) -> Void) {
		let ref = db.collection("pins").document(pin.id)
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
				let data = document.data()
				if let pin = Pin(id: document.documentID, data: data) {
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
	
	// MARK: - Upload Images
	func uploadImages(images: [UIImage], completion: @escaping ([String]) -> Void) {
		var uploadedImageURLs: [String] = []
		let dispatchGroup = DispatchGroup()
		
		for image in images {
			dispatchGroup.enter()
			
			let imageID = UUID().uuidString
			let storageRef = storage.reference().child("images/\(imageID).jpg")
			
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				print("Uploading image with ID: \(imageID)")
				
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
							print("Successfully uploaded image. URL: \(url.absoluteString)")
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
			print("All images uploaded. Image URLs: \(uploadedImageURLs)")
			completion(uploadedImageURLs)
		}
	}
	
	// MARK: - Save Pin
	func savePin(title: String, description: String, coordinate: CLLocationCoordinate2D?, images: [UIImage], completion: @escaping (Error?) -> Void) {
		guard let coordinate = coordinate else {
			completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Coordinate is required."]))
			return
		}
		
		// Upload images & get URLs
		uploadImages(images: images) { imageURLs in
			let newPin = Pin(
				id: UUID().uuidString,
				latitude: coordinate.latitude,
				longitude: coordinate.longitude,
				title: title,
				description: description,
				status: .pending,
				imageUrls: imageURLs
			)
			
			// Save new pin
			self.addPin(pin: newPin) { error in
				completion(error)
			}
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
}
