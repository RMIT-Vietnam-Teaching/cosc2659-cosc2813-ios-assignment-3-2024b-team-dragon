import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

class FirebaseService: NSObject, ObservableObject {
    private var db = Firestore.firestore()
    
    // MARK: - Create
    func addMarker(title: String, coordinate: CLLocationCoordinate2D, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("markers").document() // Automatically generate a document ID
        let newMarker = Marker(id: ref.documentID, title: title, coordinate: coordinate) // Create a new marker with the generated ID
        ref.setData(newMarker.toDictionary()) { error in
            completion(error)
        }
    }
    
    // MARK: - Read
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
    
    // MARK: - Update
    func updateMarker(marker: Marker, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("markers").document(marker.id)
        ref.setData(marker.toDictionary()) { error in
            completion(error)
        }
    }
    
    // MARK: - Delete
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
}
