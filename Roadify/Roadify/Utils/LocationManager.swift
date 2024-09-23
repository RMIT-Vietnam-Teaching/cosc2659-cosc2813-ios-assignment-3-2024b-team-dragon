/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date:
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?  // User current location
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
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

    // Updates the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

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
}
