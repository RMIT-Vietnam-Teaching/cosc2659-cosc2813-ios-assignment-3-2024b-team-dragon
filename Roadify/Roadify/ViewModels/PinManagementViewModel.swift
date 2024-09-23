/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import FirebaseFirestore
import CoreLocation
import Combine

class PinManagementViewModel: ObservableObject {
    @Published var verifiedPins: [Pin] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
    private var pinService = PinService()
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchVerifiedPins()
        bindLocationUpdates()
    }

    // Fetch pins that are marked as verified
    func fetchVerifiedPins() {
        pinService.fetchPins { result in
            switch result {
            case .success(let pins):
                self.verifiedPins = pins.filter { $0.status == .verified }
            case .failure(let error):
                print("Error fetching pins: \(error.localizedDescription)")
            }
        }
    }

    // Delete the pin
    func deletePin(_ pin: Pin) {
        pinService.deletePin(pinId: pin.id) { error in
            if let error = error {
                print("Error deleting pin: \(error.localizedDescription)")
            } else {
                print("Pin deleted successfully!")
                self.verifiedPins.removeAll { $0.id == pin.id }
            }
        }
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
