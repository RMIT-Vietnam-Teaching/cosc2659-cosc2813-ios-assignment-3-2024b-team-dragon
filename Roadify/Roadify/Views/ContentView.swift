import SwiftUI
import CoreLocation
import FirebaseStorage
import UIKit

struct ContentView: View {
    @State private var pinTitle: String = ""
    @State private var pinDescription: String = ""
    @State private var pinImages: [UIImage] = []  // Array for selected images
    @State private var showPinModal: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?  // Optional selected location
    @State private var pins: [Pin] = []  // Store pins to be passed to MapView

    let firebaseService = FirebaseService()  // Firebase service instance

    var body: some View {
        ZStack {
            // Pass the pins array to the MapView so it can display them
            MapView(pins: $pins, showPinModal: $showPinModal, selectedCoordinate: $selectedCoordinate)
                .edgesIgnoringSafeArea(.all)

            if showPinModal {
                // Show PinFormView when user long presses on the map to add a pin
                PinFormView(
                    title: $pinTitle,
                    description: $pinDescription,
                    images: $pinImages,
                    showModal: $showPinModal,
                    selectedCoordinate: $selectedCoordinate,
                    onSubmit: {
                        addPin()  // Call the function to add the pin
                    }
                )
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
            }
        }
        .onAppear {
            fetchPins()  // Fetch pins from Firebase on load
        }
    }

    // Function to add the pin after form submission
    func addPin() {
        guard let coordinate = selectedCoordinate else { return }

        // Images will be uploaded to Firebase Storage separately, their URLs will be added to the pin
        uploadImagesToFirebase(images: pinImages) { imageURLs in
            let newPin = Pin(
                id: UUID().uuidString,  // Generate a unique ID as a string
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                title: pinTitle,
                description: pinDescription,
                status: .pending,
                imageUrls: imageURLs  // Assign the image URLs here
            )

            // Add the new pin to Firebase and store it in Firestore
            firebaseService.addPin(pin: newPin) { error in
                if let error = error {
                    print("Error adding pin: \(error.localizedDescription)")
                    return
                }

                print("Pin added successfully")

                // Add the new pin to the local array of pins for immediate display on the map
                pins.append(newPin)

                // Reset form values after submission
                pinTitle = ""
                pinDescription = ""
                pinImages = []
                selectedCoordinate = nil  // Clear the selected coordinate
            }
        }
    }

    // Fetch pins from Firebase and display them on the map
    func fetchPins() {
        firebaseService.fetchPins { result in
            switch result {
            case .success(let fetchedPins):
                pins = fetchedPins
                print("Pins successfully fetched and displayed on map.")
            case .failure(let error):
                print("Error fetching pins: \(error.localizedDescription)")
            }
        }
    }

    // Upload images to Firebase Storage and get their URLs
    func uploadImagesToFirebase(images: [UIImage], completion: @escaping ([String]) -> Void) {
        var uploadedImageURLs: [String] = []
        let dispatchGroup = DispatchGroup()  // To track multiple image uploads

        for image in images {
            dispatchGroup.enter()

            // Generate a unique filename for each image
            let imageID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("images/\(imageID).jpg")

            // Compress the image
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                print("Uploading image with ID: \(imageID)")
                
                // Upload the data
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    // Retrieve the download URL for the image
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting image URL: \(error.localizedDescription)")
                        } else if let url = url {
                            print("Successfully uploaded image. URL: \(url.absoluteString)")
                            uploadedImageURLs.append(url.absoluteString)
                        }
                        dispatchGroup.leave()
                    }
                }
            } else {
                print("Error: Could not convert UIImage to JPEG data.")
                dispatchGroup.leave()
            }
        }

        // Once all images are uploaded, return the URLs
        dispatchGroup.notify(queue: .main) {
            print("All images uploaded. Image URLs: \(uploadedImageURLs)")
            completion(uploadedImageURLs)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
