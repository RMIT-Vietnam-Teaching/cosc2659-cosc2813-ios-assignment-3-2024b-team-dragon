//
//  PendingPinView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI
import Firebase

struct PendingPinView: View {
    @ObservedObject var viewModel = PendingPinViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pending Pins")
                .font(.title2)
                .bold()
            
            List(viewModel.pendingPins) { pin in
                HStack {
                    // Pin Image (Just using a placeholder for now)
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
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(pin.title)
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        Text("\(Int(pin.latitude)), \(Int(pin.longitude))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            viewModel.acceptPin(pin)
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                        }
                        
                        Button(action: {
                            viewModel.declinePin(pin)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .background(Color("MainColor"))
            .foregroundColor(.white)
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            viewModel.fetchPendingPins()
        }
    }
}

struct PendingPinView_Previews: PreviewProvider {
    static var previews: some View {
        PendingPinView()
    }
}
