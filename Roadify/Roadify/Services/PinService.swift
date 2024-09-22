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
            if let error = error {
                completion(error)
            } else {
                // Check if the pin was verified and trigger a notification
                if pin.status == .verified {
                    self.notifyUserForVerifiedPin(pin: pin)
                }
                completion(nil)
            }
        }
    }

    // Delete Pin
    func deletePin(pinId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("pins").document(pinId)
        ref.delete { error in
            completion(error)
        }
    }
    
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
    
    // Function to trigger notification for verified pin
    func notifyUserForVerifiedPin(pin: Pin) {
        let userId = pin.reportedBy
        let notificationId = pin.id  // Use the pin's unique ID as the notification ID
        
        let notificationData: [String: Any] = [
            "title": "Your pin has been verified!",
            "body": "The pin titled '\(pin.title)' has been verified by the admin.",
            "timestamp": Timestamp(date: Date()), // Store the time of notification
            "read": false // Notifications are unread by default
        ]

        // Add the notification to Firestore
        db.collection("users").document(userId).collection("notifications").document(notificationId).setData(notificationData) { error in
            if let error = error {
                print("Failed to save notification: \(error.localizedDescription)")
            } else {
                print("Notification successfully saved in Firestore.")
            }
        }
        
        // Also trigger the local notification
        let content = UNMutableNotificationContent()
        content.title = "Your pin has been verified!"
        content.body = "The pin titled '\(pin.title)' has been verified by the admin."
        content.sound = .default

        // Trigger notification after 1 second
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Request ID is the pin's unique ID
        let request = UNNotificationRequest(identifier: pin.id, content: content, trigger: trigger)

        // Add the notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification successfully scheduled.")
            }
        }
    }
    
    // Function to save notification to Firestore
    private func saveNotificationToFirestore(for pin: Pin) {
        let userId = pin.reportedBy
        
        let notificationData: [String: Any] = [
            "title": "Your pin has been verified!",
            "body": "The pin titled '\(pin.title)' has been verified by the admin.",
            "timestamp": Timestamp(date: Date()), // Store the time of notification
            "read": false // Notifications are unread by default
        ]
        
        db.collection("users").document(userId).collection("notifications").addDocument(data: notificationData) { error in
            if let error = error {
                print("Failed to save notification: \(error.localizedDescription)")
            } else {
                print("Notification successfully saved in Firestore.")
            }
        }
    }
    
    // Function to check for nearby pins
    func checkForNearbyPins(userLocation: CLLocationCoordinate2D, pins: [Pin], completion: @escaping ([Pin]) -> Void) {
        var nearbyPins: [Pin] = []
        
        for pin in pins {
            let pinLocation = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
            let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let distanceInMeters = userLocationCL.distance(from: pinLocation)
            
            // Check if the pin is within 1 km
            if distanceInMeters <= 1000 {
                nearbyPins.append(pin)
            }
        }
        
        completion(nearbyPins)  // Return the nearby pins
    }
}
