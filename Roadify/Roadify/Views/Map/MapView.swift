//
//  MapView.swift
//  Roadify
//
//  Created by Lê Phước on 9/9/24.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseStorage
import UIKit

struct MapView: View {
	// MARK: - Variables
	@StateObject private var locationManager = LocationManager()
	@State private var pinTitle: String = ""
	@State private var pinDescription: String = ""
	@State private var pinImages: [UIImage] = []  // Array for selected images
	
	@State private var selectedCoordinate: CLLocationCoordinate2D?
	@State private var startingCoordinate: CLLocationCoordinate2D?
	@State private var endingCoordinate: CLLocationCoordinate2D?
	
	@State private var startPoint: String = ""
	@State private var endPoint: String = ""
	
	@State private var pins: [Pin] = []  // Store pins to be passed to the map view
	@State private var destinationAddress: String = "" // Destination pin
	
	@State private var showPinModel: Bool = false
	@State private var showRoutingView: Bool = false
	@State private var mapView = MKMapView()
	
	let firebaseService = FirebaseService()
	let geocodingService = GeocodingService()

	
	// MARK: - Body
	var body: some View {
		ZStack {
			// MARK: - Show map
			MapViewRepresentable(
				pins: $pins,
				showPinModal: $showPinModel,
				selectedCoordinate: $selectedCoordinate,
				showRoutingView: $showRoutingView,
				startingCoordinate: $startingCoordinate,
				endingCoordinate: $endingCoordinate,
				onMapClick: { coordinate in
					if showRoutingView {
						geocodingService.getAddress(from: coordinate) { address in
							endPoint = address ?? "\(coordinate.latitude), \(coordinate.longitude)"
							endingCoordinate = coordinate
						}
					}
				}
			)
			.edgesIgnoringSafeArea(.all)
			
			// MARK: - Add pin using tapping
			if showPinModel && !showRoutingView {
				VStack {
					Spacer()
					PinFormView(
						title: $pinTitle,
						description: $pinDescription,
						images: $pinImages,
						showModal: $showPinModel,
						selectedCoordinate: $selectedCoordinate,
						onSubmit: {
							addPin()
						}
					)
					.background(Color("MainColor"))
					.transition(.move(edge: .bottom))
					.animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: showPinModel)
				}
			}
			
			// MARK: - Add pin using button
			if !showPinModel && !showRoutingView {
				VStack {
					HStack {
						Spacer()
						Button(action: {
							withAnimation {
								if let userLocation = locationManager.userLocation {
									selectedCoordinate = userLocation
								} else {
	
									print("User location is not available.")
									selectedCoordinate = nil
								}
								showPinModel = true
								print("Button pressed, showing pin form")
							}
						}) {
							Image(systemName: "location.circle.fill")
								.resizable()
								.frame(width: 50, height: 50)
								.background(Color.white)
								.clipShape(Circle())
								.shadow(radius: 4)
								.foregroundColor(Color("MainColor"))
						}
					}
					.padding(30)
					
					Spacer()
				}
			}
			
			// MARK: - Destination View
			if showRoutingView {
				VStack (spacing: 0) {
					HStack {
						Button(action: {
							withAnimation {
								showPinModel = false
								showRoutingView = false // Close the RoutingView
								dismissKeyboard() // Dismiss the keyboard
							}
						}) {
							Image(systemName: "chevron.left.circle.fill")
								.resizable()
								.frame(width: 40, height: 40)
								.background(Color.white)
								.clipShape(Circle())
								.shadow(radius: 4)
								.foregroundColor(Color("MainColor"))
						}
						.padding(.leading)
						Spacer()
					}
					RoutingView(
						startPoint: $startPoint,
						endPoint: $endPoint,
						coordinator: MapViewRepresentable.Coordinator(
							MapViewRepresentable(
								pins: $pins,
								showPinModal: $showPinModel,
								selectedCoordinate: $selectedCoordinate,
								showRoutingView: $showRoutingView,
								startingCoordinate: $startingCoordinate,
								endingCoordinate: $endingCoordinate
							),
							mapView: mapView
						)
					)
					.onAppear {
						if startPoint.isEmpty, let userLocation = locationManager.userLocation {
							startingCoordinate = userLocation
							geocodingService.getAddress(from: userLocation) { address in
								startPoint = address ?? "Current Location"
							}
						}
					}
					Spacer()
				}
			}
			
			if !showRoutingView && !showPinModel {
				VStack {
					Spacer()
					DestinationView(destinationAddress: $destinationAddress, showRoutingView: $showRoutingView)
						.onTapGesture {
							showRoutingView = true
						}
				}
			}
		}
		.onAppear {
			fetchPins()  // Fetch pins from Firebase on load
			locationManager.requestLocationPermission() // Ask user for location permission
		}
	}
	
	// MARK: - Function to add the pin after form submission
	func addPin() {
		guard let coordinate = selectedCoordinate else { return }
		
		firebaseService.savePin(title: pinTitle, description: pinDescription, coordinate: coordinate, images: pinImages) { error in
			if let error = error {
				print("Error adding pin: \(error.localizedDescription)")
				return
			}
			
			print("Pin added successfully")
			fetchPins()  // Refresh pins after adding a new one
			pinTitle = ""
			pinDescription = ""
			pinImages = []
			selectedCoordinate = nil
		}
	}
	
	// MARK: - Fetch pins from Firebase and display them on the map
	func fetchPins() {
		firebaseService.fetchPins { result in
			switch result {
			case .success(let fetchedPins):
				pins = fetchedPins
				print("Pins successfully fetched and displayed on map.")
			case .failure(let error):
				print("Error fetching pins: \(error.localizedDescription)")
			}
		}
	}
	
	func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
		let geocoder = CLGeocoder()
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
	
	func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
