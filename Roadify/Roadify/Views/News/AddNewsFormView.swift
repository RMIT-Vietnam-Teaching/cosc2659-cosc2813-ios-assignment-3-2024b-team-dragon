//
//  AddNewsFormView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct AddNewsFormView: View {
    @Binding var showModal: Bool  // Binding from parent to control visibility
    var onSubmit: () -> Void  // Closure to trigger after successfully adding news

    @State private var title: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false  // Trigger for image picker sheet
    @State private var isUploading: Bool = false  // To show loading indicator during upload
    
    @StateObject private var firebaseService = FirebaseService()

    var body: some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showModal = false  // Dismiss the view using the binding
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
                .padding(.top, 10)
                .padding(.trailing, 10)
            }

            // Title of the form
            Text("Add News")
                .foregroundStyle(Color.white)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            // TextFields for title, category, and description
            VStack(spacing: 12) {
                TextField("Title", text: $title)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                TextField("Category", text: $category)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                TextField("Description", text: $description)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 12)

            // Image Picker Button and selected image preview
            HStack(spacing: 16) {
                Button(action: {
                    showImagePicker = true
                }) {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(Color("SubColor"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                // Preview the selected image if available
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .padding(.leading, 10)
                }
            }
            .padding(.horizontal)

            // Add News button
            Button(action: {
                guard let image = selectedImage else {
                    print("No image selected!")
                    return
                }
                
                isUploading = true  // Show progress during upload
                
                let newNews = News(
                    title: title,
                    category: category,
                    description: description,
                    imageName: ""  // Image URL will be set after uploading
                )
                
                firebaseService.addNews(news: newNews, image: image) { error in
                    isUploading = false
                    if let error = error {
                        print("Error adding news: \(error.localizedDescription)")
                    } else {
                        print("News successfully added!")
                        showModal = false  // Dismiss the form
                        onSubmit()  // Trigger the onSubmit closure to refresh the news list
                    }
                }
            }) {
                Label("Add News", systemImage: "plus.circle")
                    .foregroundColor(Color("SubColor"))
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding(.top, 10)

            // Loading indicator if uploading
            if isUploading {
                ProgressView("Uploading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("SubColor")))
                    .padding()
            }

            Spacer()
        }
        .background(Color("MainColor"))
        .padding()
    }
}
