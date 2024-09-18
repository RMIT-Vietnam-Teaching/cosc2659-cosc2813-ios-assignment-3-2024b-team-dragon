//
//  GeocodingService.swift
//  Roadify
//
//  Created by Cường Võ Duy on 16/9/24.
//

import Foundation
import CoreLocation

/// A service class for geocoding coordinates to addresses and vice versa.
class GeocodingService {
	private let geocoder = CLGeocoder()
	
	/// Converts a coordinate to a human-readable address.
	/// - Parameters:
	///   - coordinate: The coordinate to convert.
	///   - completion: A closure called with the address string or `nil` if an error occurs.
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
	
	/// Converts an address to coordinates.
	/// - Parameters:
	///   - address: The address to convert.
	///   - completion: A closure called with the coordinate or `nil` if an error occurs.
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
