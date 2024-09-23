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

struct AddNewsFormView: View {
    @Binding var showModal: Bool
    var onSubmit: () -> Void

    @State private var title: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    @State private var isUploading: Bool = false
    
    @StateObject private var newsService = NewsService()

    var body: some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                Spacer()
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

                HStack {
                    TextField("Description", text: $description)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.leading)
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .padding()
                            .foregroundColor(Color("SubColor"))
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(selectedImages: $selectedImages)
                    }
                }
            }
            .padding(.bottom, 12)


            // Preview the selected images if available
            if let selectedImage = selectedImages.first {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding(.leading, 10)
            }

            // Loading indicator if uploading
            if isUploading {
                ProgressView("Uploading...")
                    .padding()
                    .progressViewStyle(ProgressViewModel(color: Color("SubColor"), textColor: Color.white, text: "Uploading..."))
            } else {
                // Add News button (only visible if not uploading)
                Button(action: {
                    guard let image = selectedImages.first else {
                        print("No image selected!")
                        return
                    }
                    
                    isUploading = true
                    
                    let newNews = News(
                        title: title,
                        category: category,
                        description: description,
                        imageName: ""
                    )
                    
                    newsService.addNews(news: newNews, image: image) { error in
                        isUploading = false
                        if let error = error {
                            print("Error adding news: \(error.localizedDescription)")
                        } else {
                            print("News successfully added!")
                            showModal = false
                            onSubmit()  
                        }
                    }
                }) {
                    Label("Add News", systemImage: "plus.circle")
                        .foregroundColor(Color("SubColor"))
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding()
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
}

struct AddNewsFormView_Previews: PreviewProvider {
    @State static var showModal = true
    
    static var previews: some View {
        AddNewsFormView(showModal: $showModal) {
            print("News added successfully!")
        }
        .preferredColorScheme(.dark)
        .frame(width: 300, height: 400)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
