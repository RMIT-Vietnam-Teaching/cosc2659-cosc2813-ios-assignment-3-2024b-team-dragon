//
//  MapView.swift
//  Roadify
//
//  Created by Lê Phước on 9/9/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var pins: [PinModel]  // Bind the pins array from ContentView
    @Binding var showPinModal: Bool
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    let mapView = MKMapView()
    let locationManager = CLLocationManager()

    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator  // Set the delegate

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove existing annotations
        uiView.removeAnnotations(uiView.annotations)

        // Add new pins as annotations
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.title
            annotation.subtitle = pin.status.rawValue  // Display the status (pending)
            uiView.addAnnotation(annotation)
        }

        // Log that the map has been updated with pins
        print("MapView: Updated map with pins")
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, mapView: mapView)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView: MKMapView

        init(_ parent: MapView, mapView: MKMapView) {
            self.parent = parent
            self.mapView = mapView
        }

        @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let touchPoint = gesture.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                
                // Capture the coordinate of the long press
                parent.selectedCoordinate = coordinate
                parent.showPinModal = true

                // Log the coordinates where the user wants to place the pin
                print("MapView: Long press detected. Coordinates - Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
            }
        }

        // Render custom pin views (if needed)
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "AccidentPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.pinTintColor = UIColor.orange  // Orange for pending pins
            } else {
                annotationView?.annotation = annotation
            }

            // Log custom pin view rendering
            print("MapView: Rendering custom pin view for annotation.")
            
            return annotationView
        }
    }
}
