//
//  PinFormView.swift
//  Roadify
//
//  Created by Lê Phước on 12/9/24.
//

import SwiftUI
import UIKit
import CoreLocation
import FirebaseStorage

struct PinFormView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var images: [UIImage]
    @Binding var showModal: Bool
    @Binding var selectedCoordinate: CLLocationCoordinate2D?  // Pass the selected coordinate for the pin

    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil  // Hold the selected image temporarily
    @State private var isUploading: Bool = false  // Show a loading state while uploading images
    
    let onSubmit: () -> Void  // This closure will be called when the user submits the form
    let firebaseService = FirebaseService()  // Create an instance of FirebaseService to save pins
    
    var body: some View {
        VStack {
            Text("Add a Pin")
                .font(.headline)
                .padding()

            TextField("Enter Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Add Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Image Picker Button
            Button(action: {
                showImagePicker = true  // Trigger the image picker
            }) {
                HStack {
                    Image(systemName: "photo")
                    Text("Add Image(s)")
                }
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)  // Present the image picker
            }
            .onChange(of: selectedImage) { newImage in
                if let image = newImage {
                    images.append(image)  // Add the new image to the images array
                }
            }

            // Image Preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(height: 120)
            
            if isUploading {
                ProgressView("Uploading...")  // Show loading indicator while uploading
                    .padding()
            }
            
            Button(action: {
                savePinToFirebase()  // Save the pin to Firebase on submit
            }) {
                Text("Pin Now")
                    .bold()
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
    
    // Save the pin to Firebase
    func savePinToFirebase() {
        guard let coordinate = selectedCoordinate else { return }
        
        isUploading = true  // Show the loading indicator while uploading
        
        // Upload images to Firebase Storage and get their URLs
        uploadImagesToFirebase(images: images) { imageURLs in
            // Create a new pin with the image URLs
            let newPin = Pin(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                title: title,
                description: description,
                status: .pending,
                imageUrls: imageURLs  // Store the image URLs in the pin model
            )
            
            // Save the new pin to Firestore
            firebaseService.addPin(pin: newPin) { error in
                isUploading = false  // Hide the loading indicator
                if let error = error {
                    print("Error saving pin to Firestore: \(error.localizedDescription)")
                } else {
                    print("Pin successfully saved to Firestore!")
                    onSubmit()  // Trigger the onSubmit action after saving
                    showModal = false  // Close the modal after submission
                }
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
