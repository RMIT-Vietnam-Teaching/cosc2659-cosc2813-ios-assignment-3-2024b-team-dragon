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
	@Binding var showPinModel: Bool
	
	@State private var showImagePicker: Bool = false
	@State private var selectedImages: [UIImage] = []  // Array for selected images
	@State private var isUploading: Bool = false  // Show a loading state while uploading images
	
	@State private var titleError: Bool = false
	@State private var descriptionError: Bool = false
	
	@State private var latitude: String = ""
	@State private var longitude: String = ""
	
	let onSubmit: (_ completion: @escaping () -> Void) -> Void
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
				.padding([.top, .trailing], 20)
				
			}
			
			Text("Add accident pin")
				.foregroundStyle(Color.white)
				.font(.title2)
				.multilineTextAlignment(.center)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding()
			
			// MARK: - Add title
			TextField(titleError ? "Title cannot be empty" : "Title", text: $title)
				.padding()
				.background(Color.white)
				.cornerRadius(10)
				.shadow(color: .gray, radius: 1, x: 0, y: 2)
				.padding([.trailing, .leading])
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(titleError ? Color.red : Color.clear, lineWidth: 3)
						.padding([.trailing, .leading])
				)
				.onChange(of: title) {
					titleError = false
				}
				.padding([.leading, .trailing])
			
			HStack (spacing: 0) {
				// MARK: - Add description
				TextField(descriptionError ? "Description cannot be empty" : "Description", text: $description)
					.padding()
					.background(Color.white)
					.cornerRadius(10)
					.shadow(color: .gray, radius: 1, x: 0, y: 1)
					.overlay(
						RoundedRectangle(cornerRadius: 10)
							.stroke(descriptionError ? Color.red : Color.clear, lineWidth: 3)
					)
					.onChange(of: description) {
						descriptionError = false
					}
					.padding(.leading)
				
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
				.padding([.leading, .trailing])
				.onChange(of: selectedImages) { newImages in
					images.append(contentsOf: newImages)  // Append the selected images
				}
			}
			.padding()
			
			// MARK: - Pin Longitude and Latitude
			VStack(alignment: .leading, spacing: 10) {
				Text("Pin Location")
					.foregroundStyle(Color("SubColor"))
					.font(.headline)
					.padding([.leading, .bottom])
				
				// Latitude
				HStack {
					Text("Latitude")
						.font(.subheadline)
						.foregroundStyle(.gray)
						.frame(width: 80)
						.padding(.leading)
					
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
						.padding(.trailing)
				}
				
				// Longitude
				HStack {
					Text("Longitude")
						.font(.subheadline)
						.foregroundColor(.gray)
						.frame(width: 80)
						.padding(.leading)

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
						.padding(.trailing)
				}
			}
			.padding([.top, .leading, .trailing])
			
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
			
			// MARK: - Loading indicator/ Add pin button
			HStack {
				if isUploading {
					Spacer()
					ProgressView("Uploading...")
						.progressViewStyle(
							ProgressViewModel(
								color: Color("SubColor"), textColor: Color.white,
								text: "Uploading..."))
				} else {
					Button {
						validateAndSubmit()
					} label: {
						Label("Add Pin", systemImage: "plus.circle")
							.foregroundStyle(Color("SubColor"))
					}
					.buttonStyle(.bordered)
					.controlSize(.large)
					.padding([.bottom, .trailing, .leading])
				}
			}
		}
		.background(Color("MainColor"))
		.cornerRadius(15)
		.overlay(
			RoundedRectangle(cornerRadius: 15)
				.stroke(Color.white.opacity(0.2), lineWidth: 2)
		)
		.shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
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
				showModal = false  // Close the modal after submission
			}
		}
	}
	
	// MARK: - Validation Function
	func validateAndSubmit() {
		// Reset errors
		titleError = false
		descriptionError = false
		
		// Validate title /description
		if title.isEmpty {
			titleError = true
		}
		if description.isEmpty {
			descriptionError = true
		}
		
		if titleError || descriptionError {
			return
		}
		
		isUploading = true
		onSubmit {
			isUploading = false
			showPinModel = false
		}
	}
}

struct PinFormView_Previews: PreviewProvider {
	@State static var title: String = "Sample Pin Title"
	@State static var description: String = "Sample Pin Description"
	@State static var images: [UIImage] = []  // Empty array for now
	@State static var showModal: Bool = true
	@State static var selectedCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(
		latitude: 37.7749, longitude: -122.4194)  // Example coordinate
	static var previews: some View {
		PinFormView(
			title: $title,
			description: $description,
			images: $images,
			showModal: $showModal,
			selectedCoordinate: $selectedCoordinate,
			showPinModel: .constant(true),
			onSubmit: { completion in
				completion()
			}
		)
		.previewLayout(.sizeThatFits)  // Adjusts preview size to fit the content
	}
}
