//
//  AddNewsFormView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct AddNewsFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false  // Trigger for image picker sheet
    @State private var isUploading: Bool = false  // To show loading indicator during upload
    
    @StateObject private var firebaseService = FirebaseService()

    var body: some View {
        VStack {
            Text("Add News")
                .font(.largeTitle)
                .padding()

            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Category", text: $category)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Button to show image picker
            Button("Select Image") {
                showImagePicker = true
            }
            .padding()

            // Show selected image preview if available
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            // Button to add news
            Button("Add News") {
                guard let image = selectedImage else {
                    print("No image selected!")
                    return
                }
                
                isUploading = true  // Show progress during upload
                
                // Create the News object without the image URL first
                let newNews = News(
                    title: title,
                    category: category,
                    description: description,
                    imageName: ""  // The image URL will be set after uploading
                )
                
                // Upload image and save news to Firebase
                firebaseService.addNews(news: newNews, image: image) { error in
                    isUploading = false  // Stop progress indicator
                    if let error = error {
                        print("Error adding news: \(error.localizedDescription)")
                    } else {
                        print("News successfully added!")
                        presentationMode.wrappedValue.dismiss()  // Close the form after submission
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            // Show a loading indicator while uploading
            if isUploading {
                ProgressView("Uploading...").padding()
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)  // Present the image picker when the button is tapped
        }
    }
}
