import Firebase
import CoreLocation
import UIKit

class PinService: FirebaseService {
    // Add Pin
    func addPin(pin: Pin, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pin.id)
        ref.setData(pin.toDictionary()) { error in
            completion(error)
        }
    }

    // Fetch Pins
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
                }
            }
            completion(.success(pins))
        }
    }

    // Update Pin
    func updatePin(pin: Pin, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pin.id)
        ref.setData(pin.toDictionary()) { error in
            completion(error)
        }
    }

    // Delete Pin
    func deletePin(pinId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pinId)
        ref.delete { error in
            completion(error)
        }
    }
    
	// MARK: - Save Pin
	func savePin(title: String, description: String, coordinate: CLLocationCoordinate2D?, images: [UIImage], user: User, completion: @escaping (Error?) -> Void) {
		guard let coordinate = coordinate else {
			completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Coordinate is required."]))
			return
		}

		let imageUploadService = ImageUploadService()

		// Upload images & get URLs
		imageUploadService.uploadImages(images: images) { imageURLs in
			let newPin = Pin(
				id: UUID().uuidString,
				latitude: coordinate.latitude,
				longitude: coordinate.longitude,
				title: title,
				description: description,
				status: .pending,
				imageUrls: imageURLs,
				timestamp: Date(),
				reportedBy: user.id
			)

			// Save new pin
			self.addPin(pin: newPin) { error in
				completion(error)
			}
		}
	}
}
