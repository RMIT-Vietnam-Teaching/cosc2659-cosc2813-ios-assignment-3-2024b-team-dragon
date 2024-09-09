import SwiftUI

@main
struct RoadifyApp: App {
    @UIApplicationDelegateAdaptor(FirebaseService.self) var delegate  // Register FirebaseService as AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
