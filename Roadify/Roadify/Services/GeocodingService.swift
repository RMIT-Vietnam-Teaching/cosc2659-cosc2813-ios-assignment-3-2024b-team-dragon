/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 16/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import CoreLocation

class GeocodingService {
	private let geocoder = CLGeocoder()
	
	func getAddress(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		geocoder.reverseGeocodeLocation(location) { placemarks, error in
			if let error = error {
				print("Reverse geocoding failed: \(error.localizedDescription)")
				completion(nil)
				return
			}
			
			if let placemark = placemarks?.first {
				var address = ""
				if let street = placemark.thoroughfare {
					address += street
				}
				if let city = placemark.locality {
					address += ", \(city)"
				}
				if let state = placemark.administrativeArea {
					address += ", \(state)"
				}
				if let postalCode = placemark.postalCode {
					address += " \(postalCode)"
				}
				if let country = placemark.country {
					address += ", \(country)"
				}
				completion(address)
			} else {
				completion(nil)
			}
		}
	}
	
	func getCoordinate(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
		geocoder.geocodeAddressString(address) { placemarks, error in
			if let error = error {
				print("Geocoding failed: \(error.localizedDescription)")
				completion(nil)
				return
			}
			
			if let placemark = placemarks?.first, let location = placemark.location {
				completion(location.coordinate)
			} else {
				completion(nil)
			}
		}
	}
}
