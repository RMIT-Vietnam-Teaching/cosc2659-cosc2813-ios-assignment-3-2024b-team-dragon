import SwiftUI
import UIKit

struct EditProfileView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var profileImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedImage: Image?
    @State private var address: String = ""
    @State private var mobilePhone: String = ""
    @State private var username: String = ""
    @Environment(\.presentationMode) var presentationMode // To close the view
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.title2)
                .bold()
            
            // Profile Image Upload Section
            HStack {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else if let profileImageUrl = URL(string: viewModel.profileImageUrl), !viewModel.profileImageUrl.isEmpty {
                    AsyncImage(url: profileImageUrl) { image in
                        image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }

                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Change Profile Image")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingImagePicker, content: {
                    ImagePicker(image: $profileImage, selectedImage: $selectedImage)
                })
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.1)))
            
            // Username Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.headline)
                TextField("Enter your username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                    .foregroundColor(.white)
            }
            
            // Address Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Address")
                    .font(.headline)
                TextField("Enter your address", text: $address)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                    .foregroundColor(.white)
            }
            
            // Mobile Phone Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Mobile Phone")
                    .font(.headline)
                TextField("Enter your mobile phone", text: $mobilePhone)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                    .foregroundColor(.white)
            }
            
            // Save Button
            Button(action: {
                // Save profile changes
                viewModel.saveProfile(username: username, address: address, mobilePhone: mobilePhone, profileImage: profileImage)
                
                // Dismiss the view after saving
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Save Changes")
                        .foregroundColor(Color("FourthColor"))
                        .bold()
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("SecondaryColor")))
            }
            
            Spacer()
        }
        .padding()
        .background(Color("PrimaryColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            // Initialize fields with the current profile data
            self.address = viewModel.address
            self.mobilePhone = viewModel.mobilePhone
            self.username = viewModel.username
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var selectedImage: Image?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed for now
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.selectedImage = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}
