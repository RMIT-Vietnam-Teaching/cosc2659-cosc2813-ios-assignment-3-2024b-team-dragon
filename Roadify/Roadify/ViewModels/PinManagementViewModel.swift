//
//  PinManagementViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class PinManagementViewModel: ObservableObject {
    @Published var verifiedPins: [Pin] = []
    private var pinService = PinService()

    init() {
        fetchVerifiedPins()
    }

    // Fetch pins that are marked as verified
    func fetchVerifiedPins() {
        pinService.fetchPins { result in
            switch result {
            case .success(let pins):
                self.verifiedPins = pins.filter { $0.status == .verified }  // Only show verified pins
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
                self.verifiedPins.removeAll { $0.id == pin.id }  // Remove from local list
            }
        }
    }
}
