import SwiftUI
import Combine
import CoreLocation

class AlertViewModel: ObservableObject {
    @Published var pins: [Pin] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    
    private var firebaseService: FirebaseService
    private var cancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager
    
    init(firebaseService: FirebaseService = FirebaseService(), locationManager: LocationManager = LocationManager()) {
        self.firebaseService = firebaseService
        self.locationManager = locationManager
        fetchPins()
        bindLocationUpdates()
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
    
    // Fetch pins from Firebase through FirebaseService
    func fetchPins() {
        firebaseService.fetchPins { [weak self] result in
            switch result {
            case .success(let fetchedPins):
                DispatchQueue.main.async {
                    self?.pins = fetchedPins
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
