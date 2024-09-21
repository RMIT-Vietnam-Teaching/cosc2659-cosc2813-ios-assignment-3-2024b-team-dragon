import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

class FirebaseService: NSObject, ObservableObject {
    var db = Firestore.firestore()
    let storage = Storage.storage()

    // MARK: - Log Activity
    func logActivity(action: String, metadata: [String: Any]? = nil) {
        guard let user = Auth.auth().currentUser else { return }

        let logData: [String: Any] = [
            "userId": user.uid,
            "action": action,
            "timestamp": Timestamp(date: Date()),
            "metadata": metadata ?? [:],
        ]

        db.collection("activityLogs").addDocument(data: logData) { error in
            if let error = error {
                print("Error logging activity: \(error.localizedDescription)")
            }
        }
    }

    // Function to get the currently logged-in user
    func getCurrentUser() -> User? {
        if let firebaseUser = Auth.auth().currentUser {
            return User(
                id: firebaseUser.uid,
                username: firebaseUser.displayName ?? "",
                firstName: "",  // Add actual user info if needed
                lastName: "",  // Add actual user info if needed
                email: firebaseUser.email ?? "",
                createdAt: Date(),  // Replace with actual createdAt date if available
                isAdmin: false  // Default to false, change based on your logic
            )
        }
        return nil
    }

    // MARK: - Save User Details to Firestore using User model
    func saveUser(user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).setData(user.toDictionary()) { error in
            if let error = error {
                completion(error)
            } else {
                // Log the profile update activity
                // Log the profile update activity
                self.logActivity(
                    action: NSLocalizedString("profile_action_updated", comment: "Profile Updated"),
                    metadata: ["username": user.username])
                completion(nil)
            }
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
                    completion(
                        .failure(
                            NSError(
                                domain: "", code: 400,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                }
            } else {
                completion(
                    .failure(
                        NSError(
                            domain: "", code: 404,
                            userInfo: [NSLocalizedDescriptionKey: "User not found"])))
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
                    completion(
                        .failure(
                            NSError(
                                domain: "", code: 400,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                }
            } else {
                completion(
                    .failure(
                        NSError(
                            domain: "", code: 404,
                            userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
}
