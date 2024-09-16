import SwiftUI
import CoreLocation
import Combine

class AlertViewModel: ObservableObject {
    @Published var pins: [Pin] = []
    @Published var errorMessage: String? = nil
    
    private var firebaseService: FirebaseService
    private var cancellables = Set<AnyCancellable>()
    
    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
        fetchPins()
    }
    
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
    
    func calculateDistance(pin: Pin) -> Double {
        let userLocation = CLLocation(latitude: 10.762622, longitude: 106.660172)
        let pinLocation = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
        return userLocation.distance(from: pinLocation) / 1000  // Convert to km
    }
}
