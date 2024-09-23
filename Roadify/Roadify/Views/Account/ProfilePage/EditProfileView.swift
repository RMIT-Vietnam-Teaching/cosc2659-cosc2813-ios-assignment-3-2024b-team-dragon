/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

//
//  EditProfileView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
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
    @Environment(\.presentationMode) var presentationMode  // To close the view

    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("editProfile_title", comment: "No email available"))
                .font(.title2)
                .bold()

            // Profile Image Upload Section
            HStack {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else if let profileImageUrl = URL(string: viewModel.profileImageUrl),
                    !viewModel.profileImageUrl.isEmpty
                {
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
                    Text(NSLocalizedString("editProfile_image", comment: "Change Profile Image"))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .sheet(
                    isPresented: $showingImagePicker,
                    content: {
                        ProfileImagePicker(image: $profileImage, selectedImage: $selectedImage)
                    })
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.1)))

            // Username Input
            VStack(alignment: .leading, spacing: 8) {
                Text(
                    NSLocalizedString(
                        "editProfile_username", comment: "Username of Edit Profile View")
                )
                .font(.headline)
                TextField(
                    NSLocalizedString(
                        "editProfile_promptUsername", comment: "Prompt to change username"),
                    text: $username
                )
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5))
                )
                .foregroundColor(.white)
            }

            // Address Input
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("editProfile_address", comment: "Address"))
                    .font(.headline)
                TextField(
                    NSLocalizedString(
                        "editProfile_promptAddress", comment: "Prompt to change address"),
                    text: $address
                )
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5))
                )
                .foregroundColor(.white)
            }

            // Mobile Phone Input
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("mobilePhone", comment: "add mobile phone"))
                    .font(.headline)
                TextField(
                    NSLocalizedString(
                        "editProfile_promptMobile", comment: "Prompt to change Mobile"),
                    text: $mobilePhone
                )
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5))
                )
                .foregroundColor(.white)
            }

            // Save Button
            Button(action: {
                // Save profile changes
                viewModel.saveProfile(
                    username: username, address: address, mobilePhone: mobilePhone,
                    profileImage: profileImage)

                // Dismiss the view after saving
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text(NSLocalizedString("saveProfile", comment: "Save edit profile"))
                        .foregroundColor(Color("FourthColor"))
                        .bold()
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("SubColor")))
            }

            Spacer()
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            self.address = viewModel.address
            self.mobilePhone = viewModel.mobilePhone
            self.username = viewModel.username
        }
    }
}

struct ProfileImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var selectedImage: Image?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ProfileImagePicker

        init(_ parent: ProfileImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.selectedImage = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}
