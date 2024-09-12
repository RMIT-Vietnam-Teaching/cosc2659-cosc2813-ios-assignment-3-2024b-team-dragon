import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

class FirebaseService: ObservableObject {
    private var db = Firestore.firestore()  // Access Firestore through Firebase

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
}
