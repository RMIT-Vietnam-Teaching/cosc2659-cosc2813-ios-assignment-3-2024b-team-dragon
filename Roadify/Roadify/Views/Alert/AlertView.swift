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

struct AlertView: View {
	@ObservedObject var viewModel = AlertViewModel()
	
	@Binding var selectedPin: Pin?
	@Binding var selectedTab: Int
	@Binding var isFromMapView: Bool
	
	var body: some View {
		NavigationView {
			ZStack {
				Color("MainColor").ignoresSafeArea()
				
				VStack(spacing: 20) {
					// Title Section
					Text("Alerts")
						.font(.system(size: 28, weight: .bold))
						.foregroundColor(Color.white)
						.padding(.top, 20)
					
					// Search Bar
					SearchBar(label: "Search Alerts", text: $viewModel.searchText)
					
					if let pin = selectedPin {
						NavigationLink(
							destination: AlertDetailsView(
								viewModel: AlertDetailsViewModel(pin: pin)
							)
							.onDisappear {
								selectedPin = nil
							},
							isActive: .constant(isFromMapView && selectedPin != nil)
						) {
						}
					} else {
						// List of Pins
						List(viewModel.filteredPins) { pin in
							NavigationLink(
								destination: AlertDetailsView(
									viewModel: AlertDetailsViewModel(pin: pin)),
								label: {
									HStack {
										// Display Pin image
										if let imageUrl = pin.imageUrls.first, !imageUrl.isEmpty {
											AsyncImage(url: URL(string: imageUrl)) { image in
												image
													.resizable()
													.frame(width: 60, height: 60)
													.cornerRadius(8)
											} placeholder: {
												ProgressView()
											}
										} else {
											Image(systemName: "photo")
												.resizable()
												.frame(width: 60, height: 60)
												.cornerRadius(8)
												.foregroundColor(.gray)
										}
										
										// Display Pin title and distance
										VStack(alignment: .leading, spacing: 5) {
											Text(pin.title)
												.foregroundColor(Color("SubColor"))
												.font(.headline)
											Text(
												"\(viewModel.calculateDistance(pin: pin), specifier: "%.1f") km"
											)
											.foregroundColor(.gray)
											.font(.subheadline)
										}
									}
								}
							)
							.listRowBackground(Color("MainColor"))
						}
						.listStyle(PlainListStyle())
					}
				}
				.background(Color("MainColor"))
				.navigationBarHidden(true)
			}
		}
		.accentColor(Color("SubColor"))
		.onAppear {
			viewModel.fetchVerifiedPins()
		}
		.navigationBarBackButtonHidden(true) 
	}
}

struct AlertView_Previews: PreviewProvider {
	@State static var selectedTab = 2
	@State static var selectedPin: Pin? = nil
	@State static var isFromMapView: Bool = false
	
	static var previews: some View {
		AlertView(
			selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
	}
}
