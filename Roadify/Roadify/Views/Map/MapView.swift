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
	@State private var showPinModel: Bool = false
	@State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
	@State private var pins: [Pin] = []  // Store pins to be passed to the map view
	
	let firebaseService = FirebaseService()  // Firebase service instance
	
	// MARK: - Body
	var body: some View {
		ZStack (alignment: .bottomTrailing) {
			// MARK: - Show map
			MapViewRepresentable(pins: $pins, showPinModal: $showPinModel, selectedCoordinate: $selectedCoordinate)
				.edgesIgnoringSafeArea(.all)
			
			// MARK: - Add pin using tapping
			if showPinModel {
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
				.background(Color("Primary"))
				.frame(width: .infinity)
				.clipShape(RoundedCornerViewModel(radius: 25, corners: [.topLeft, .topRight]))
				.transition(.move(edge: .bottom))
				.animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: showPinModel)
			}
			
			// MARK: - Add pin using button
			if !showPinModel {
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
					Image(systemName: "plus.circle.fill")
						.resizable()
						.frame(width: 50, height: 50)
						.background(Color.white)
						.clipShape(Circle())
						.shadow(radius: 4)
						.foregroundColor(.blue)
				}
				.padding([.trailing, .bottom], 30)
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
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
