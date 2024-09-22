//
//  MapView.swift
//  Roadify
//
//  Created by Lê Phước on 9/9/24.
//

import CoreLocation
import FirebaseStorage
import MapKit
import SwiftUI
import UIKit

struct MapView: View {
    // MARK: - Variables
    @StateObject private var locationManager = LocationManager()
    @StateObject private var authManager = AuthManager()

    @State private var pinTitle: String = ""
    @State private var pinDescription: String = ""
    @State private var pinImages: [UIImage] = []  // Array for selected images

    @Binding var selectedPin: Pin?
    @Binding var selectedTab: Int
    @Binding var isFromMapView: Bool

    @State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
    @State private var startingCoordinate: CLLocationCoordinate2D?
    @State private var endingCoordinate: CLLocationCoordinate2D?

    @State private var startPoint: String = ""
    @State private var endPoint: String = ""

    @State private var pins: [Pin] = []  // Store pins to be passed to the map view
    @State private var destinationAddress: String = ""  // Destination pin

    @State private var showPinModel: Bool = false
    @State private var showRoutingView: Bool = false
    @State private var mapView = MKMapView()

    let firebaseService = FirebaseService()  // Firebase service instance
    let geocodingService = GeocodingService()
    let pinService = PinService()  // Pin service instance

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
                mapView: $mapView,
                selectedPin: $selectedPin,
                endPoint: $endPoint,
                selectedTab: $selectedTab,
                authManager: authManager,
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
            .onTapGesture {
                withAnimation {
                    showRoutingView = false  // Close DestinationView when users tap outside

                    // Clear existing routes
                    let coordinator = MapViewRepresentable.Coordinator(
                        MapViewRepresentable(
                            pins: $pins,
                            showPinModal: $showPinModel,
                            selectedCoordinate: $selectedCoordinate,
                            showRoutingView: $showRoutingView,
                            startingCoordinate: $startingCoordinate,
                            endingCoordinate: $endingCoordinate,
                            mapView: $mapView,
                            selectedPin: $selectedPin,
                            endPoint: $endPoint,
                            selectedTab: $selectedTab,
                            authManager: authManager
                        ),
                        mapView: mapView
                    )
                    coordinator.removeRoutes()
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
                        showPinModel: $showPinModel,
                        onSubmit: { completion in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                completion()
                            }
                            addPin()
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5),
                        value: showPinModel)
                }
            }

            if !showPinModel && !showRoutingView {
                VStack {
                    HStack {
                        // MARK: - Move to current location
                        Button(action: {
                            withAnimation {
                                if let userLocation = locationManager.userLocation {
                                    selectedCoordinate = userLocation
                                    mapView.centerToCoordinate(userLocation)
                                } else {
                                    print("User location is not available.")
                                    selectedCoordinate = nil
                                }
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
                        Spacer()

                        // MARK: - Add pin using button
                        Button(action: {
                            if authManager.isLoggedIn {
                                withAnimation {
                                    if let userLocation = locationManager.userLocation {
                                        selectedCoordinate = userLocation
                                    } else {
                                        // print("User location is not available.")
                                        selectedCoordinate = nil
                                    }
                                    showPinModel = true
                                }
                            } else {
                                selectedTab = 3  // Switch to signin/signup view
                            }
                            // print("Button pressed, showing pin form")
                        }) {
                            Image(systemName: "plus.circle.fill")
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
            if showRoutingView && !showPinModel {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showPinModel = false
                                showRoutingView = false  // Close the RoutingView
                                dismissKeyboard()  // Dismiss the keyboard

                                // Remove existing route
                                let coordinator = MapViewRepresentable.Coordinator(
                                    MapViewRepresentable(
                                        pins: $pins,
                                        showPinModal: $showPinModel,
                                        selectedCoordinate: $selectedCoordinate,
                                        showRoutingView: $showRoutingView,
                                        startingCoordinate: $startingCoordinate,
                                        endingCoordinate: $endingCoordinate,
                                        mapView: $mapView,
                                        selectedPin: $selectedPin,
                                        endPoint: $endPoint,
                                        selectedTab: $selectedTab,
                                        authManager: authManager
                                    ),
                                    mapView: mapView
                                )
                                coordinator.removeRoutes()
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
                                endingCoordinate: $endingCoordinate,
                                mapView: $mapView,
                                selectedPin: $selectedPin,
                                endPoint: $endPoint,
                                selectedTab: $selectedTab,
                                authManager: authManager
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
                    DestinationView(
                        destinationAddress: $destinationAddress, showRoutingView: $showRoutingView
                    )
                    .onTapGesture {
                        showRoutingView = true
                    }
                }
            }

            // Present the detail view
            if let pin = selectedPin {
                VStack {
                    Spacer()
                    DetailPinView(
                        selectedPin: $selectedPin,
                        selectedTab: $selectedTab,
                        isFromMapView: $isFromMapView,
                        pin: pin)
                }

            }
        }
        .onAppear {
            fetchPins()
            fetchVerifiedPins()
            selectedPin = nil
            locationManager.requestLocationPermission()  // Ask user for location permission
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
            fetchPins()
            fetchVerifiedPins()
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

    // MARK: - Fetch only verified pins from Firebase and display them on the map
    func fetchVerifiedPins() {
        pinService.fetchPins { result in
            switch result {
            case .success(let fetchedPins):
                pins = fetchedPins.filter { $0.status == .verified }  // Filter to show only verified pins
                print("Verified pins successfully fetched and displayed on map.")
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
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var selectedPin: Pin?
    @State static var selectedTab: Int = 0
    @State static var isFromMapView: Bool = false

    static var previews: some View {
        MapView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
    }
}
