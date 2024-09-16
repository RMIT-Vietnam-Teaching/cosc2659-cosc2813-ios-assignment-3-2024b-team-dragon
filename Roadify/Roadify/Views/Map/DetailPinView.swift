//
//  DetailPinView.swift
//  Roadify
//
//  Created by Lê Phước on 16/9/24.
//

import SwiftUI

struct DetailPinView: View {
    @Binding var selectedPin: Pin?
    let pin: Pin  // The pin to display details for
    
    var body: some View {
        VStack(spacing: 20) {
            Text(pin.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            // Time of the pin report
            Text("Reported at: \(formattedDate(pin.timestamp))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Pin description
            Text(pin.description)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            // Reporter ID
            Text("Reported by: \(pin.reportedBy)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            // Image from the pin
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(pin.imageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
            }
            
            // View in Alert Button
            Button(action: {
                // Action for viewing in Alert
                print("View in Alert pressed")
            }) {
                Label("View in Alert", systemImage: "bell.fill")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Pin Details", displayMode: .inline)
    }
    
    // Helper to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
