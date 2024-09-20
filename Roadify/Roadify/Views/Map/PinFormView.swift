import SwiftUI
import UIKit
import CoreLocation
import FirebaseStorage

struct PinFormView: View {
    // MARK: - Variables
    @Binding var title: String
    @Binding var description: String
    @Binding var images: [UIImage]
    @Binding var showModal: Bool
    @Binding var selectedCoordinate: CLLocationCoordinate2D?  // Pass the selected coordinate for the pin

    @State private var showImagePicker: Bool = false
    @State private var selectedImages: [UIImage] = []  // Array for selected images
    @State private var isUploading: Bool = false  // Show a loading state while uploading images

    @State private var latitude: String = ""
    @State private var longitude: String = ""

    let onSubmit: () -> Void  // This closure will be called when the user submits the form
    let firebaseService = FirebaseService()  // Create an instance of FirebaseService to save pins
    let pinService = PinService()

    // MARK: - Body
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Spacer()

                // MARK: - Form close button
                Button(action: {
                    withAnimation {
                        showModal = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
                .padding(.top, 10)
                .padding(.trailing, 10)
            }

            Text("Press on the map\nto pin accidents or traffic jams")
                .foregroundStyle(Color.white)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            // MARK: - Add title
            TextField("Title", text: $title)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                .padding([.trailing,.leading])

            HStack (spacing: 0) {
                // MARK: - Add description
                TextField("Description", text: $description)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 1, x: 0, y: 1)

                // MARK: - Add Image
                Button(action: {
                    showImagePicker = true  // Trigger the image picker
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundStyle(Color("SubColor"))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(width: 60)
                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(selectedImages: $selectedImages)  // Pass selectedImages
                        .edgesIgnoringSafeArea(.bottom)
                }
                .padding(.leading)
                .onChange(of: selectedImages) { newImages in
                    images.append(contentsOf: newImages)  // Append the selected images
                }
            }
            .padding()

            // MARK: - Pin Longitude and Latitude
            VStack(alignment: .leading, spacing: 10) {
                Text("Pin Location")
                    .foregroundStyle(Color.white)
                    .font(.headline)
                    .padding(.bottom, 5)

                // Latitude
                HStack {
                    Text("Latitude")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(width: 80)

                    TextField("Latitude", text: $latitude)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            if let coordinate = selectedCoordinate {
                                latitude = String(coordinate.latitude)
                            }
                        }
                }

                // Longitude
                HStack {
                    Text("Longitude")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 80)

                    TextField("Longitude", text: $longitude)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            if let coordinate = selectedCoordinate {
                                longitude = String(coordinate.longitude)
                            }
                        }
                }
            }
            .padding()

            // MARK: - Image Preview
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

            // Loading indicator
            if isUploading {
                ProgressView("Uploading...")
                    .padding()
                    .progressViewStyle(ProgressViewModel(color: Color("SubColor"), textColor: Color.white, text: "Uploading..."))
            }

            // MARK: - Add pin button
            Button {
                savePin()
            } label: {
                Label(String("Add Pin"), systemImage: "plus.circle")
                    .foregroundStyle(Color("SubColor"))
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
        }
        .background(Color("MainColor"))
        .padding()
    }

    // Save the pin to Firebase
    func savePin() {
        guard let coordinate = selectedCoordinate else { return }

        isUploading = true  // Show the loading indicator while uploading

        // Fetch the current user from Firebase Authentication
        guard let currentUser = firebaseService.getCurrentUser() else {
            print("Error: User not logged in")
            return
        }

        // Save the pin to Firebase, passing the user and current timestamp
        pinService.savePin(
            title: title,
            description: description,
            coordinate: coordinate,
            images: images,
            user: currentUser  // Pass the current user
        ) { error in
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
