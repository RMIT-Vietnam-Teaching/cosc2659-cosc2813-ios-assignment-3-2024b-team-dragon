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
