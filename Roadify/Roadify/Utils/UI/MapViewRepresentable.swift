//
//  MapViewRepresentable.swift
//  Roadify
//
//  Created by Cường Võ Duy on 14/9/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
	@Binding var pins: [Pin]
	@Binding var showPinModal: Bool
	@Binding var selectedCoordinate: CLLocationCoordinate2D?
	@Binding var showRoutingView: Bool
	@Binding var startingCoordinate: CLLocationCoordinate2D?
	@Binding var endingCoordinate: CLLocationCoordinate2D?
	@Binding var mapView: MKMapView

	var onMapClick: ((CLLocationCoordinate2D) -> Void)?
	let locationManager = CLLocationManager()
	
	// MARK: - makeUIView function
	func makeUIView(context: Context) -> MKMapView {
		mapView.delegate = context.coordinator

		mapView.showsUserLocation = true
		mapView.userTrackingMode = .follow
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		
		let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gesture:)))
		mapView.addGestureRecognizer(longPressGesture)
		
		return mapView
	}
	
	// MARK: - updateUIView function
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
	
	// MARK: - makeCoordinator function
	func makeCoordinator() -> Coordinator {
		let coordinator = Coordinator(self, mapView: mapView)
		mapView.delegate = coordinator
		return coordinator
	}
	
	
	
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapViewRepresentable
		var mapView: MKMapView
		
		init(_ parent: MapViewRepresentable, mapView: MKMapView) {
			self.parent = parent
			self.mapView = mapView
		}
		
		// MARK: - Handle Long press
		@objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
			if gesture.state == .began {
				let touchPoint = gesture.location(in: mapView)
				let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
				
				parent.selectedCoordinate = coordinate
				parent.showPinModal = true
				parent.onMapClick?(coordinate)
				
				print("MapView: Long press detected. Coordinates - Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
			}
		}
		
		// MARK: - drawRoute function
		func drawRoute(startPoint: String, endPoint: String) {
			let geocodingService = GeocodingService()
			
			// Geocode the starting point
			geocodingService.getCoordinate(from: startPoint) { startCoordinate in
				guard let startCoordinate = startCoordinate else {
					print("Failed to get starting coordinate")
					return
				}
				print("Starting Coordinate: \(startCoordinate)")
				
				// Geocode the end point
				geocodingService.getCoordinate(from: endPoint) { endCoordinate in
					guard let endCoordinate = endCoordinate else {
						print("Failed to get ending coordinate")
						return
					}
					print("Ending Coordinate: \(endCoordinate)")
					
					// configure the directions request
					let startPlacemark = MKPlacemark(coordinate: startCoordinate)
					let endPlacemark = MKPlacemark(coordinate: endCoordinate)
					
					let request = MKDirections.Request()
					request.source = MKMapItem(placemark: startPlacemark)
					request.destination = MKMapItem(placemark: endPlacemark)
					
					let directions = MKDirections(request: request)
					
					directions.calculate { response, error in
						if let error = error {
							print("Error calculating directions: \(error.localizedDescription)")
							return
						}
						
						guard let route = response?.routes.first else {
							print("No route found")
							return
						}
						
//						print("Route found with distance: \(route.distance) meters")
						
						// Add the route as an overlay on the map
						self.parent.mapView.addOverlay(route.polyline)
						self.parent.mapView.setVisibleMapRect(
							route.polyline.boundingMapRect,
							edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
							animated: true
						)
					}
				}
			}
		}

		// MARK: - removeRoute function
		func removeRoutes() {
			let overlays = mapView.overlays
			mapView.removeOverlays(overlays.filter { $0 is MKPolyline })
		}

		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			print("Renderer requested for overlay")
			if let polyline = overlay as? MKPolyline {
				let renderer = MKPolylineRenderer(polyline: polyline)
				renderer.strokeColor = UIColor.red
				renderer.lineWidth = 3
				return renderer
			}
			return MKOverlayRenderer()
		}
		
		func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
			let centerCoordinate = mapView.centerCoordinate
			parent.selectedCoordinate = centerCoordinate
			print("MapView: Region changed. Center coordinates - Latitude: \(centerCoordinate.latitude), Longitude: \(centerCoordinate.longitude)")
		}
		
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			let identifier = "AccidentPin"
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
			
			if annotationView == nil {
				annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				annotationView?.canShowCallout = true
//				annotationView?.pinTintColor = UIColor.orange
			} else {
				annotationView?.annotation = annotation
			}
			
			print("MapView: Rendering custom pin view for annotation.")
			
			return annotationView
		}
	}
	
	

}
