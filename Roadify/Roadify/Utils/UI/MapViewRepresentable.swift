import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var pins: [Pin]
    @Binding var showPinModal: Bool
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var selectedPin: Pin?  // New binding for the selected pin
	@Binding var mapView: MKMapView
	
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
        
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            let centerCoordinate = mapView.centerCoordinate
//            parent.selectedCoordinate = centerCoordinate
////            print("MapView: Region changed. Center coordinates - Latitude: \(centerCoordinate.latitude), Longitude: \(centerCoordinate.longitude)")
//        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "AccidentPin"
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier) 
                annotationView?.canShowCallout = true
				annotationView?.tintColor = UIColor.orange
            } else {
                annotationView?.annotation = annotation
            }
            
            print("MapView: Rendering custom pin view for annotation.")
            
            return annotationView
        }
        
        // Handle pin selection
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            
            let selectedLat = annotation.coordinate.latitude
            let selectedLon = annotation.coordinate.longitude
            
            // Find the corresponding pin from the pins array
            if let selectedPin = parent.pins.first(where: { pin in
                pin.latitude == selectedLat && pin.longitude == selectedLon
            }) {
                parent.selectedPin = selectedPin  // Set the selected pin
                print("MapView: Pin selected - \(selectedPin.title)")
            }
        }
    }
}

extension MKMapView {
	func centerToCoordinate(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
		let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
		self.setRegion(region, animated: animated)
	}
}
