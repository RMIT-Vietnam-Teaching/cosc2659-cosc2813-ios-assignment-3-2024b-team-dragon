//
//  PendingPinViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import Foundation
import Firebase

class PendingPinViewModel: ObservableObject {
    @Published var pendingPins: [Pin] = []
    private var pinService = PinService()
    
    init() {
        fetchPendingPins()
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
}
