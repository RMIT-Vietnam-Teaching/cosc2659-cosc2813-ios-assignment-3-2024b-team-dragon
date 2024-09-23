/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date:
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var selectedImages: [UIImage]
    @ObservedObject var viewModel = ImagePickerViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempSelectedImages: Set<UIImage> = []

    var body: some View {
        NavigationView {
            VStack {
                // Add padding to move content down
                Spacer()
                
                // Top action buttons and title
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .foregroundColor(Color(.blue))
                    
                    Spacer()
                    
                    Text("Photos")
                        .font(.title3)
                        .foregroundColor(Color("SubColor"))
                        .bold()
                    
                    Spacer()
                    
                    Button("Done") {
                        // Update the binding with selected images and dismiss
                        selectedImages = Array(tempSelectedImages)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .foregroundColor(Color(.blue))
                }
                .background(Color("MainColor"))

                // Move the search bar under the title
                HStack {
                    TextField("Search", text: .constant(""))
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 8)

                // Grid of images with custom background color
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                        ForEach(viewModel.images, id: \.self) { image in
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Rectangle())
                                    .overlay(
                                        tempSelectedImages.contains(image) ?
                                        Color.black.opacity(0.4) : Color.clear
                                    )
                                
                                if tempSelectedImages.contains(image) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(Color("MainColor"))
                                }
                            }
                            .onTapGesture {
                                if tempSelectedImages.contains(image) {
                                    tempSelectedImages.remove(image)
                                } else {
                                    tempSelectedImages.insert(image)
                                }
                            }
                        }
                    }
                    .padding(4)
                    .background(Color("MainColor"))
                }
                .background(Color("MainColor"))
                
                Spacer()
            }
            .background(Color("MainColor"))
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.requestPhotoLibraryAccess()
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(selectedImages: .constant([]))
    }
}
