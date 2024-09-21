import Firebase
import FirebaseCore
import SwiftUI

@main
struct RoadifyApp: App {
	@State private var selectedPin: Pin?
	@State private var selectedTab: Int = 0
	@State private var isFromMapView: Bool = false
	@State private var isDetailPinViewPresented: Bool = false

	
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
			SplashScreenView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView, isDetailPinViewPresented: $isDetailPinViewPresented)
        }
    }
}
