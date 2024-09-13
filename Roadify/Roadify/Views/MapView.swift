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
	@State private var pinTitle: String = ""
	@State private var pinDescription: String = ""
	@State private var pinImages: [UIImage] = []  // Array for selected images
	@State private var showPinModal: Bool = false
	@State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
	@State private var pins: [Pin] = []  // Store pins to be passed to the map view
	
	let firebaseService = FirebaseService()  // Firebase service instance
	
	var body: some View {
		ZStack (alignment: .bottom) {
			MapViewRepresentable(pins: $pins, showPinModal: $showPinModal, selectedCoordinate: $selectedCoordinate)
				.edgesIgnoringSafeArea(.all)
			
			if showPinModal {
				PinFormView(
					title: $pinTitle,
					description: $pinDescription,
					images: $pinImages,
					showModal: $showPinModal,
					selectedCoordinate: $selectedCoordinate,
					onSubmit: {
						addPin()  // Call the function to add the pin
					}
				)
				.background(Color("Primary"))
				.frame(width: .infinity)
				.clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
				.padding(.top)
			}
		}
		.onAppear {
			fetchPins()  // Fetch pins from Firebase on load
		}
	}
	
	// Function to add the pin after form submission
	func addPin() {
		guard let coordinate = selectedCoordinate else { return }
		
		uploadImagesToFirebase(images: pinImages) { imageURLs in
			let newPin = Pin(
				id: UUID().uuidString,  // Generate a unique ID as a string
				latitude: coordinate.latitude,
				longitude: coordinate.longitude,
				title: pinTitle,
				description: pinDescription,
				status: .pending,
				imageUrls: imageURLs  // Assign the image URLs here
			)
			
			firebaseService.addPin(pin: newPin) { error in
				if let error = error {
					print("Error adding pin: \(error.localizedDescription)")
					return
				}
				
				print("Pin added successfully")
				pins.append(newPin)
				pinTitle = ""
				pinDescription = ""
				pinImages = []
				selectedCoordinate = nil
			}
		}
	}
	
	// Fetch pins from Firebase and display them on the map
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
	
	// Upload images to Firebase Storage and get their URLs
	func uploadImagesToFirebase(images: [UIImage], completion: @escaping ([String]) -> Void) {
		var uploadedImageURLs: [String] = []
		let dispatchGroup = DispatchGroup()  // To track multiple image uploads
		
		for image in images {
			dispatchGroup.enter()
			
			let imageID = UUID().uuidString
			let storageRef = Storage.storage().reference().child("images/\(imageID).jpg")
			
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				print("Uploading image with ID: \(imageID)")
				
				storageRef.putData(imageData, metadata: nil) { (metadata, error) in
					if let error = error {
						print("Error uploading image: \(error.localizedDescription)")
						dispatchGroup.leave()
						return
					}
					
					storageRef.downloadURL { (url, error) in
						if let error = error {
							print("Error getting image URL: \(error.localizedDescription)")
						} else if let url = url {
							print("Successfully uploaded image. URL: \(url.absoluteString)")
							uploadedImageURLs.append(url.absoluteString)
						}
						dispatchGroup.leave()
					}
				}
			} else {
				print("Error: Could not convert UIImage to JPEG data.")
				dispatchGroup.leave()
			}
		}
		
		dispatchGroup.notify(queue: .main) {
			print("All images uploaded. Image URLs: \(uploadedImageURLs)")
			completion(uploadedImageURLs)
		}
	}
}

struct MapViewRepresentable: UIViewRepresentable {
	@Binding var pins: [Pin]  // Bind the pins array from ContentView
	@Binding var showPinModal: Bool
	@Binding var selectedCoordinate: CLLocationCoordinate2D?
	
	let mapView = MKMapView()
	let locationManager = CLLocationManager()
	
	func makeUIView(context: Context) -> MKMapView {
		mapView.showsUserLocation = true
		mapView.userTrackingMode = .follow
		mapView.delegate = context.coordinator
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		
		let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gesture:)))
		mapView.addGestureRecognizer(longPressGesture)
		
		return mapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		uiView.removeAnnotations(uiView.annotations)
		
		for pin in pins {
			let annotation = MKPointAnnotation()
			annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
			annotation.title = pin.title
			annotation.subtitle = pin.status.rawValue
			uiView.addAnnotation(annotation)
		}
		
		print("MapView: Updated map with pins")
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self, mapView: mapView)
	}
	
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapViewRepresentable
		var mapView: MKMapView
		
		init(_ parent: MapViewRepresentable, mapView: MKMapView) {
			self.parent = parent
			self.mapView = mapView
		}
		
		@objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
			if gesture.state == .began {
				let touchPoint = gesture.location(in: mapView)
				let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
				
				parent.selectedCoordinate = coordinate
				parent.showPinModal = true
				
				print("MapView: Long press detected. Coordinates - Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
			}
		}
		
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			let identifier = "AccidentPin"
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
			
			if annotationView == nil {
				annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				annotationView?.canShowCallout = true
				annotationView?.pinTintColor = UIColor.orange
			} else {
				annotationView?.annotation = annotation
			}
			
			print("MapView: Rendering custom pin view for annotation.")
			
			return annotationView
		}
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
