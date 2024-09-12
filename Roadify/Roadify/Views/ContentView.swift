import SwiftUI
import CoreLocation
import UIKit

struct ContentView: View {
    @State private var pinTitle: String = ""
    @State private var pinDescription: String = ""
    @State private var pinImages: [UIImage] = []
    @State private var showPinModal: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?  // Keep it optional
    @State private var pins: [Pin] = []  // Store pins to be passed to MapView

    var body: some View {
        ZStack {
            // Pass the pins array to the MapView so it can display them
            MapView(pins: $pins, showPinModal: $showPinModal, selectedCoordinate: $selectedCoordinate)
                .edgesIgnoringSafeArea(.all)

            if showPinModal {
                // Pass the selectedCoordinate binding to PinFormView as well
                PinFormView(title: $pinTitle, description: $pinDescription, images: $pinImages, showModal: $showPinModal, selectedCoordinate: $selectedCoordinate, onSubmit: {
                    addPin()
                })
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
            }
        }
    }

    // Function to add the pin after form submission
    func addPin() {
        guard let coordinate = selectedCoordinate else { return }

        // Create a new pin with the provided title, description, and images
        let newPin = Pin(
            id: UUID().uuidString,  // Generate a unique ID as a string
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            title: pinTitle,
            description: pinDescription,
            status: .pending,  // This should be PinStatus, not an array of images
            images: pinImages  // Assign the images here
        )

        // Add the new pin to the array
        pins.append(newPin)

        // Reset form values after submission
        pinTitle = ""
        pinDescription = ""
        pinImages = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
