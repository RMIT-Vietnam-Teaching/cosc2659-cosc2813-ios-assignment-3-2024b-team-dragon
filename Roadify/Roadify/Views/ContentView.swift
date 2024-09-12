import SwiftUI
import CoreLocation
import UIKit

struct ContentView: View {
    @State private var pinTitle: String = ""
    @State private var pinDescription: String = ""
    @State private var pinImages: [UIImage] = []
    @State private var showPinModal: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var pins: [PinModel] = []  // Store pins to be passed to MapView

    var body: some View {
        ZStack {
            // Pass the pins array to the MapView so it can display them
            MapView(pins: $pins, showPinModal: $showPinModal, selectedCoordinate: $selectedCoordinate)
                .edgesIgnoringSafeArea(.all)
            
            if showPinModal {
                // Show the form when the modal is triggered
                PinFormView(title: $pinTitle, description: $pinDescription, images: $pinImages, showModal: $showPinModal, onSubmit: {
                    // Handle form submission and add the pin to the map
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
        let newPin = PinModel(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            status: .pending,
            title: pinTitle,
            description: pinDescription,
            images: pinImages
        )
        
        // Add the new pin to the array
        pins.append(newPin)
        
        // Reset form values after submission
        pinTitle = ""
        pinDescription = ""
        pinImages = []
    }
}

struct ContentView_Providerr: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
