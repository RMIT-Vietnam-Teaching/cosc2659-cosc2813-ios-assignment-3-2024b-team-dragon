//
//  UserManagementView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI

struct UserManagementView: View {
    @ObservedObject var viewModel = UserManagementViewModel()
    @Environment(\.presentationMode) var presentationMode  // To handle the back button

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Back button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Go back to the previous view (AdminPanelView)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }

                Spacer()

                // Centered title
                Text("User Management")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .padding()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.users) { user in
                        VStack {
                            HStack {
                                // Static profile image (Placeholder for now)
                                Image("staticProfilePlaceholder")  // Use your placeholder image name
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.headline)
                                        .foregroundColor(Color("SubColor"))  // Adjust based on color scheme
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                HStack {
                                    Button(action: {
                                        viewModel.approveUser(user)
                                    }) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.green)
                                    }
                                    
                                    Button(action: {
                                        viewModel.rejectUser(user)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .background(Color("MainColor").opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Add a gray line (divider) below each user rectangle
                            Divider()
                                .background(Color.gray)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            viewModel.fetchNonAdminUsers()
        }
    }
}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        UserManagementView()
    }
}
