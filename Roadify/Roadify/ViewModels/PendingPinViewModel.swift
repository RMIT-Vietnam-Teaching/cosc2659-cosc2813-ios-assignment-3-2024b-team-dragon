//
//  PendingPinViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import Foundation
import Firebase
import CoreLocation
import Combine

class PendingPinViewModel: ObservableObject {
    @Published var pendingPins: [Pin] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
    private var pinService = PinService()
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchPendingPins()
        bindLocationUpdates()
    }
    
    // Fetch pending pins from the Firestore database
    func fetchPendingPins() {
        pinService.fetchPins { result in
            switch result {
            case .success(let pins):
                // Filter only pending pins
                self.pendingPins = pins.filter { $0.status == .pending }
            case .failure(let error):
                print("Error fetching pins: \(error.localizedDescription)")
            }
        }
    }
    
    // Accept a pin and update its status to "verified"
    func acceptPin(_ pin: Pin) {
        var updatedPin = pin
        updatedPin.status = .verified
        pinService.updatePin(pin: updatedPin) { error in
            if let error = error {
                print("Error accepting pin: \(error.localizedDescription)")
            } else {
                self.removePinFromList(pin)
            }
        }
    }
    
    // Decline a pin by deleting it from Firestore
    func declinePin(_ pin: Pin) {
        pinService.deletePin(pinId: pin.id) { error in
            if let error = error {
                print("Error declining pin: \(error.localizedDescription)")
            } else {
                self.removePinFromList(pin)
            }
        }
    }
    
    // Helper function to remove the pin from the list
    private func removePinFromList(_ pin: Pin) {
        self.pendingPins.removeAll { $0.id == pin.id }
    }
    
    // Bind LocationManager updates to track user location
    private func bindLocationUpdates() {
        locationManager.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.userLocation = location
            }
            .store(in: &cancellables)
    }
    
    // Calculate distance between the user's location and a pin
    func calculateDistance(pin: Pin) -> Double {
        guard let userLocation = userLocation else { return 0 }
        let pinLocation = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
        let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return userLocationCL.distance(from: pinLocation) / 1000  // Convert to kilometers
    }
}
