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

struct AlertDetailsView: View {
	@ObservedObject var viewModel: AlertDetailsViewModel
	
	var body: some View {
		VStack(spacing: 20) {
			VStack {
				Text("Alerts")
					.font(.title)
					.foregroundColor(Color.white)
					.padding(.top, 10)
				
				Text(viewModel.pin.title)
					.font(.headline)
					.foregroundColor(Color.white)
				
				Text(Formatter.formatDate(viewModel.pin.timestamp))
					.font(.subheadline)
					.foregroundColor(Color.white)
			}
			.padding(.bottom, 10)
			
			// Image Section
			if let imageUrl = viewModel.pin.imageUrls.first, !imageUrl.isEmpty {
				AsyncImage(url: URL(string: imageUrl)) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 200)
						.cornerRadius(8)
				} placeholder: {
					ProgressView()
				}
			}
			
			// Likes and Dislikes Buttons
			HStack(spacing: 20) {
				HStack {
					Button(action: {
						viewModel.incrementLikes()
					}) {
						HStack {
							Text("\(viewModel.pin.likes)")
								.font(.headline)
								.foregroundColor(.white)
							Image(systemName: "hand.thumbsup.fill")
								.foregroundColor(.green)
						}
					}
				}
				
				HStack {
					Button(action: {
						viewModel.incrementDislikes()
					}) {
						HStack {
							Text("\(viewModel.pin.dislikes)")
								.font(.headline)
								.foregroundColor(.white)
							Image(systemName: "hand.thumbsdown.fill")
								.foregroundColor(.red)
						}
					}
				}
			}
			.padding(.vertical, 10)
			
			// Description Section
			VStack(alignment: .leading, spacing: 5) {
				Text(viewModel.pin.description)
					.font(.body)
					.foregroundColor(.white)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 10)
			
			Spacer()
		}
		.padding()
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.navigationBarTitleDisplayMode(.inline)  
	}
}

struct AlertDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		let mockPin = Pin(
			id: "1",
			latitude: 10.762622,
			longitude: 106.660172,
			title: "Two Cars Crash At The Cross Road",
			description: "No casualties, slow traffic.",
			status: .verified,
			imageUrls: ["https://via.placeholder.com/300"],
			timestamp: Date(),
			reportedBy: "String",
			likes: 15,
			dislikes: 2
		)
		let viewModel = AlertDetailsViewModel(pin: mockPin)
		AlertDetailsView(viewModel: viewModel)
	}
}

