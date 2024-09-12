//
//  PinFormView.swift
//  Roadify
//
//  Created by Lê Phước on 12/9/24.
//

import SwiftUI
import UIKit

struct PinFormView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var images: [UIImage]
    @Binding var showModal: Bool
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil  // Hold the selected image temporarily
    let onSubmit: () -> Void  // This closure will be called when the user submits the form
    
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
            
            Button(action: {
                onSubmit()
                showModal = false  // Close the modal after submission
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
}
