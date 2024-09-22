/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement:
 */

import SwiftUI
import Combine
import CoreLocation

class AlertViewModel: ObservableObject {
    @Published var pins: [Pin] = []
    @Published var filteredPins: [Pin] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    
    private var firebaseService: FirebaseService
    private var pinService: PinService
    private var cancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager
    
    init(firebaseService: FirebaseService = FirebaseService(), pinService: PinService = PinService(), locationManager: LocationManager = LocationManager()) {
        self.firebaseService = firebaseService
        self.pinService = pinService
        self.locationManager = locationManager
        fetchVerifiedPins()
        bindLocationUpdates()
        bindSearchText()
    }
    
    // Bind to LocationManager's updates to observe the user's location
    private func bindLocationUpdates() {
        locationManager.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.userLocation = location
            }
            .store(in: &cancellables)
    }
    
    // Bind searchText to filter pins dynamically
    private func bindSearchText() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Delay the filtering slightly
            .sink { [weak self] searchText in
                self?.filterPins(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    // Filter pins based on the search text
    private func filterPins(searchText: String) {
        if searchText.isEmpty {
            filteredPins = pins
        } else {
            filteredPins = pins.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // Fetch only verified pins from Firebase through FirebaseService
    func fetchVerifiedPins() {
        pinService.fetchPins { [weak self] result in
            switch result {
            case .success(let fetchedPins):
                DispatchQueue.main.async {
                    self?.pins = fetchedPins.filter { $0.status == .verified }  // Filter only verified pins
                    self?.filteredPins = self?.pins ?? []
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = "Error fetching pins: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Calculate distance between the user's location and a pin
    func calculateDistance(pin: Pin) -> Double {
        guard let userLocation = userLocation else { return 0 }
        let pinLocation = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
        let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return userLocationCL.distance(from: pinLocation) / 1000  // Convert to km
    }
}
