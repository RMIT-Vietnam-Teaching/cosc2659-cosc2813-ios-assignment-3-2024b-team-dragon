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
		VStack (spacing: 0) {
			HStack {
				Spacer()
				
				Button(action: {
					showModal = false
				}) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.gray)
						.font(.system(size: 24))
				}
				.padding(.top, 10)
				.padding(.trailing, 10)
			}

            Text("Press on the map\nto pin accidents or traffic jams")
				.foregroundStyle(Color("Secondary"))
                .font(.title2)
				.multilineTextAlignment(.center)
				.frame(maxWidth: .infinity, alignment: .center)
                .padding()

			TextField("Title", text: $title)
				.padding()
				.background(Color("Primary"))
				.foregroundStyle(Color("Secondary"))
				.cornerRadius(10)
				.shadow(color: .gray, radius: 1, x: 0, y: 0)
				.padding([.trailing,.leading])
			
			HStack (spacing: 0) {
				TextField("Description", text: $description)
					.padding()
					.background(Color("Primary"))
					.foregroundStyle(Color("Secondary"))
					.cornerRadius(10)
					.shadow(color: .gray, radius: 1, x: 0, y: 0)

				Button(action: {
					showImagePicker = true  // Trigger the image picker
				}) {
					HStack {
						Image(systemName: "photo")
							.font(.system(size: 20))
					}
					.padding()
					.background(Color("Primary"))
					.cornerRadius(10)
					.frame(width: 60)
					.shadow(color: .gray, radius: 1, x: 0, y: 0)
				}
				.sheet(isPresented: $showImagePicker) {
					ImagePicker(selectedImage: $selectedImage)
						.edgesIgnoringSafeArea(.bottom)
				}
				.padding(.leading)
				.onChange(of: selectedImage) { newImage in
					if let image = newImage {
						images.append(image)
					}
				}
			}
			.padding()

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
			.padding()
//            .frame(height: 120)
            
            if isUploading {
                ProgressView("Uploading...")  // Show loading indicator while uploading
                    .padding()
            }
            
			Button {
				savePinToFirebase()  // Save the pin to Firebase on submit
			} label: {
				Label(String("Add Pin"), systemImage: "plus.circle")
			}
			.foregroundStyle(Color("Secondary"))
			.buttonStyle(.bordered)
			.controlSize(.large)
			.padding()
        }
		.background(Color("Primary"))
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

struct PinFormView_Previews: PreviewProvider {
	@State static var title: String = "Sample Pin Title"
	@State static var description: String = "Sample Pin Description"
	@State static var images: [UIImage] = []  // Empty array for now
	@State static var showModal: Bool = true
	@State static var selectedCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example coordinate
	
	static var previews: some View {
		PinFormView(
			title: $title,
			description: $description,
			images: $images,
			showModal: $showModal,
			selectedCoordinate: $selectedCoordinate,
			onSubmit: {
				// Add action to be performed on submit if needed
				print("Pin submitted")
			}
		)
		.previewLayout(.sizeThatFits)  // Adjusts preview size to fit the content
	}
}
