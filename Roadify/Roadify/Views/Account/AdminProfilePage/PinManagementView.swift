//
//  PinManagementView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI

struct PinManagementView: View {
    @ObservedObject var viewModel = PinManagementViewModel()
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
                Text("Pin Management")
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
                    ForEach(viewModel.verifiedPins) { pin in
                        VStack {
                            HStack {
                                // Pin Image (Placeholder for now)
                                if let imageUrl = pin.imageUrls.first, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Rectangle())
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 60, height: 60)
                                    }
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 60, height: 60)
                                }

                                VStack(alignment: .leading) {
                                    Text(pin.title)
                                        .font(.headline)
                                        .foregroundColor(Color("SubColor"))  // Adjust based on color scheme
                                    
                                    Text("\(String(format: "%.1f", pin.latitude)), \(String(format: "%.1f", pin.longitude)) km")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button(action: {
                                    viewModel.deletePin(pin)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 8)
                            .background(Color("MainColor").opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Add a gray line (divider) below each pin rectangle
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
            viewModel.fetchVerifiedPins()
        }
    }
}

struct PinManagementView_Previews: PreviewProvider {
    static var previews: some View {
        PinManagementView()
    }
}
