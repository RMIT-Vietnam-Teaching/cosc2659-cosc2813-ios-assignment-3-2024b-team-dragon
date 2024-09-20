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
    @State private var selectedPin: Pin? = nil
    @State private var showPinModel: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
    @State private var pins: [Pin] = []  // Store pins to be passed to the map view
    @State private var destinationAddress: String = "" // Destination pin
    @State private var showRoutingView: Bool = false
    
    let firebaseService = FirebaseService()  // Firebase service instance
    let pinService = PinService()  // Pin service instance
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Show map
            MapViewRepresentable(pins: $pins, showPinModal: $showPinModel, selectedCoordinate: $selectedCoordinate, selectedPin: $selectedPin)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showRoutingView = false // Close DestinationView when users tap outside
                    }
                }
            
            // MARK: - Add pin using tapping
            if showPinModel {
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
                VStack {
                    RoutingView()
                    Spacer()
                }
            }
            
            if !showRoutingView && !showPinModel {
                VStack {
                    Spacer()
                    DestinationView(destinationAddress: $destinationAddress, showRoutingView: $showRoutingView)
                }
            }
        }
        .onAppear {
            fetchPins()  // Fetch pins from Firebase on load
            locationManager.requestLocationPermission() // Ask user for location permission
        }
        // Present the detail view
        if let pin = selectedPin {
            VStack {
                Spacer()
                DetailPinView(selectedPin: $selectedPin, pin: pin)
                    .background(Color("MainColor"))
                    .transition(.move(edge: .bottom))
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5))
            }
        }
    }
    
    // MARK: - Function to add the pin after form submission
    func addPin() {
        guard let coordinate = selectedCoordinate else { return }
        
        // Fetch the current user from Firebase Authentication
        guard let currentUser = firebaseService.getCurrentUser() else {
            print("Error: User not logged in")
            return
        }
        
        // Save the pin to Firebase, passing the user instance
        pinService.savePin(
            title: pinTitle,
            description: pinDescription,
            coordinate: coordinate,
            images: pinImages,
            user: currentUser  // Pass the current logged-in user
        ) { error in
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
        pinService.fetchPins { result in
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
