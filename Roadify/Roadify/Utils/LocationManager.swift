//
//  LocationManager.swift
//  Roadify
//
//  Created by Cường Võ Duy on 15/9/24.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var userLocation: CLLocationCoordinate2D?  // User's current location
	private var locationManager = CLLocationManager()
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		requestLocationPermission()
	}
	
	// Request location permission
	func requestLocationPermission() {
		if CLLocationManager.locationServicesEnabled() {
			let status = locationManager.authorizationStatus
			
			switch status {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .restricted, .denied:
				print("Location access restricted or denied.")
			case .authorizedWhenInUse, .authorizedAlways:
				locationManager.startUpdatingLocation()
			default:
				break
			}
		} else {
			print("Location services are not enabled.")
		}
	}
	
	// Updates the user's location
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		DispatchQueue.main.async {
			self.userLocation = location.coordinate
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
