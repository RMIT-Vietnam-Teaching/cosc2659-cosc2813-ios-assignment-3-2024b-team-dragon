import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

class FirebaseService: ObservableObject {
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
}
