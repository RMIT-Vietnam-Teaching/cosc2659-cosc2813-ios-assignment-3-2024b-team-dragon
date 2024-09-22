import CoreLocation
import MapKit
import SwiftUI
import UserNotifications

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?  // User's current location
    private var locationManager = CLLocationManager()
    private var pinService = PinService()
    private var nearbyPins: [Pin] = []
    private var checkNearbyPinsTimer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
        startCheckingForNearbyPins()  // Start checking for nearby pins
    }
    
    // Request location permission
    func requestLocationPermission() {
        let unResponsivenessUI = DispatchQueue(label: "unResponsivenessUI")
        unResponsivenessUI.async {
            if CLLocationManager.locationServicesEnabled() {
                let status = self.locationManager.authorizationStatus

                switch status {
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    print("Location access restricted or denied.")
                case .authorizedWhenInUse, .authorizedAlways:
                    self.locationManager.startUpdatingLocation()
                default:
                    break
                }
            } else {
                print("Location services are not enabled.")
            }
        }
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    // Check location authorization status changes
    func locationManager(
        _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .notDetermined:
            print("Location permission not determined.")
        case .restricted, .denied:
            print("Location permission denied.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    // Periodically check for nearby pins
    func startCheckingForNearbyPins() {
        checkNearbyPinsTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.checkForNearbyPins()
        }
    }
    
    // Stop checking for nearby pins
    func stopCheckingForNearbyPins() {
        checkNearbyPinsTimer?.invalidate()
        checkNearbyPinsTimer = nil
    }
    
    // Fetch pins and check if they are near the user
    private func checkForNearbyPins() {
        guard let userLocation = userLocation else { return }
        
        pinService.fetchPins { [weak self] result in
            switch result {
            case .success(let pins):
                let verifiedPins = pins.filter { $0.status == .verified }
                self?.pinService.checkForNearbyPins(userLocation: userLocation, pins: verifiedPins) { nearbyPins in
                    self?.handleNearbyPins(nearbyPins)
                }
            case .failure(let error):
                print("Error fetching pins: \(error.localizedDescription)")
            }
        }
    }
    
    // Handle nearby pins and send notifications
    private func handleNearbyPins(_ nearbyPins: [Pin]) {
        if nearbyPins.count != self.nearbyPins.count {
            self.nearbyPins = nearbyPins
            sendNearbyPinsNotification(count: nearbyPins.count)
        }
        
        // If the same number of pins but different pins, also send a notification
        let newPinIDs = Set(nearbyPins.map { $0.id })
        let currentPinIDs = Set(self.nearbyPins.map { $0.id })
        if !newPinIDs.isSubset(of: currentPinIDs) {
            sendNearbyPinsNotification(count: nearbyPins.count)
        }
    }
    
    // Send a notification about nearby pins
    private func sendNearbyPinsNotification(count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Accidents Nearby"
        content.body = "There are \(count) accidents within 1 km of your location."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification successfully scheduled.")
            }
        }
    }
}
