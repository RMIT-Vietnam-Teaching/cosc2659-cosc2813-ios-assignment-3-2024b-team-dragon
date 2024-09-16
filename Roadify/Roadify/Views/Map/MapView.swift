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
	@State private var pinTitle: String = ""
	@State private var pinDescription: String = ""
	@State private var pinImages: [UIImage] = []  // Array for selected images
	@State private var showPinModel: Bool = false
	@State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
	@State private var pins: [Pin] = []  // Store pins to be passed to the map view
	@State private var destinationAddress: String = "" // Destination pin
	
	let firebaseService = FirebaseService()  // Firebase service instance
	
	// MARK: - Body
	var body: some View {
		ZStack {
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
				VStack {
					HStack {
						Spacer()
						Button(action: {
							withAnimation {
								selectedCoordinate = nil
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
								.foregroundColor(Color("PrimaryColor"))
						}
					}
					.padding(30)

					Spacer()
				}
			}
			
			VStack {
				Spacer()
				VStack {
					Spacer().frame(height: 20)
					HStack {
						Text("Where are you going to?")
							.foregroundStyle(Color.white)
						Spacer()
					}
					.padding(.leading)
					
					HStack {
						TextField("Enter destination", text: $destinationAddress)
							.padding()
							.background(Color.white)
							.cornerRadius(8)
							.shadow(radius: 4)
							.padding(.leading)
						
						Button(action: {
							geocodeAddress(address: destinationAddress) { coordinate in
								if let coordinate = coordinate {
									print("Destination coordinates: \(coordinate.latitude), \(coordinate.longitude)")
									self.selectedCoordinate = coordinate
								} else {
									print("Could not find location for the entered address")
								}
							}
						}) {
							Text("Go")
								.padding()
								.background(Color("SecondaryColor"))
								.foregroundColor(Color("PrimaryColor"))
								.cornerRadius(8)
								.shadow(radius: 4)
						}
						.padding(.trailing)
					}
					Spacer().frame(height: 20)
				}
				.background(Color("PrimaryColor"))
				.cornerRadius(12)
				.padding()
				.shadow(radius: 5)
			}
			.padding(.bottom, 10)
		}
		.onAppear {
			fetchPins()  // Fetch pins from Firebase on load
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

}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
