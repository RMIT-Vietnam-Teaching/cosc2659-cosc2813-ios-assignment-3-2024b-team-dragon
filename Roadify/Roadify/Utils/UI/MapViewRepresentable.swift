//
//  MapViewRepresentable.swift
//  Roadify
//
//  Created by Cường Võ Duy on 14/9/24.
//

import Foundation
import SwiftUI
import MapKit

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
