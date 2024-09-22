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

import Foundation

class AlertDetailsViewModel: ObservableObject {
    @Published var pin: Pin
    private var pinService = PinService()

    init(pin: Pin) {
        self.pin = pin
    }

    func incrementLikes() {
        pin.likes += 1
        updatePinInFirebase()
    }

    func incrementDislikes() {
        pin.dislikes += 1
        updatePinInFirebase()
    }

    private func updatePinInFirebase() {
        pinService.updatePin(pin: pin) { error in
            if let error = error {
                print("Failed to update pin: \(error.localizedDescription)")
            } else {
                print("Pin updated successfully")
            }
        }
    }
}
