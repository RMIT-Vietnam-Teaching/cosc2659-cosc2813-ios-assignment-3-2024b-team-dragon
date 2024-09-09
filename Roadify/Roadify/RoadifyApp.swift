import SwiftUI
import Firebase

@main
struct RoadifyApp: App {
    init() {
        FirebaseApp.configure()
        print("Firebase Configured!")
    }
    
    var body: some Scene {
        WindowGroup {
            CRUDView()
        }
    }
}

