import SwiftUI
import PhotosUI

struct NewsView: View {
    @StateObject private var firebaseService = FirebaseService()
    @State private var selectedImage: UIImage?
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showImagePicker: Bool = false

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            Button("Upload News Item") {
                if let selectedImage = selectedImage {
                    firebaseService.uploadPhoto(selectedImage: selectedImage, title: title, description: description) { error in
                        if let error = error {
                            print("Error uploading news item: \(error.localizedDescription)")
                        } else {
                            print("News item uploaded successfully!")
                        }
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("Upload News")
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
