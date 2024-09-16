//
//  DestinationView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 16/9/24.
//

import SwiftUI

struct RoutingView: View {
	@Binding var startingPoint: String
	@Binding var endPoint: String
	
	var body: some View {
		VStack {
			HStack {
				Image("direction")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 80)
					.padding(.leading)
				
				VStack (spacing: 15) {
					// Starting Point
					TextField("Starting Point", text: $startingPoint)
						.padding()
						.background(Color.white)
						.cornerRadius(8)
						.shadow(radius: 4)
						.disabled(true)
					
					HStack {
						// End Point
						TextField("End Point", text: $endPoint)
							.padding()
							.background(Color.white)
							.cornerRadius(8)
							.shadow(radius: 4)
						
						Button(action: {
							print("Starting Point: \(startingPoint)")
							print("End Point: \(endPoint)")
						}) {
							Text("Go")
								.padding()
								.background(Color("SubColor"))
								.foregroundColor(Color("MainColor"))
								.cornerRadius(8)
								.shadow(radius: 4)
						}
					}
				}
				.padding([.trailing, .top, .bottom])
			}
		}
		.background(Color("MainColor"))
		.cornerRadius(15)
		.padding()
		.shadow(radius: 5)
	}
}

struct RoutingView_Previews: PreviewProvider {
	static var previews: some View {
		RoutingView(startingPoint: .constant("37.7749, -122.4194"),
					endPoint: .constant("34.0522, -118.2437"))
	}
}
