import Foundation
import Firebase

class FirebaseService: NSObject, UIApplicationDelegate {
    override init() {
        super.init()
        FirebaseApp.configure()  
        print("Configured Firebase!")
    }
}
