import SwiftUI
import Firebase
import FirebaseCore

@main
struct RoadifyApp: App {
    init() {
        FirebaseApp.configure()
        print("Firebase Configured!")
		
//		// For debug: clear UserDefaults
//		let defaults = UserDefaults.standard
//		let dictionary = defaults.dictionaryRepresentation()
//		dictionary.keys.forEach { key in
//			defaults.removeObject(forKey: key)
//		}
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

