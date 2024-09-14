import SwiftUI
import Firebase
import FirebaseCore

@main
struct RoadifyApp: App {
    init() {
        FirebaseApp.configure()
        print("Firebase Configured!")
    }
    
    var body: some Scene {
        WindowGroup {
            TabView()
        }
    }
}

