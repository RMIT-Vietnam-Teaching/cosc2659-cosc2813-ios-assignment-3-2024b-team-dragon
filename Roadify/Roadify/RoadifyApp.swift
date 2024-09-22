/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date:
 Last modified: 22/9/24
 Acknowledgement:
 */

import Firebase
import FirebaseCore
import SwiftUI
import UserNotifications

@main
struct RoadifyApp: App {
	@State private var selectedPin: Pin?
	@State private var selectedTab: Int = 0
	@State private var isFromMapView: Bool = false
	
    init() {
        FirebaseApp.configure()
        print("Firebase Configured!")

        requestNotificationPermission()

        // Set the delegate to handle notifications in the foreground
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }

    var body: some Scene {
        WindowGroup {
			SplashScreenView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
        }
    }

    // Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}

// Custom Notification Manager for foreground notifications
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    // Handle notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])  // Display the notification as an alert with sound
    }
}
