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
import MapKit

struct RoutingView: View {
	@Binding var startPoint: String
	@Binding var endPoint: String
	var coordinator: MapViewRepresentable.Coordinator
	
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
					TextField("Starting Point", text: $startPoint)
						.padding()
						.background(Color.white)
						.cornerRadius(8)
						.shadow(radius: 4)
					
					HStack {
						// End Point
						TextField("End Point", text: $endPoint)
							.padding()
							.background(Color.white)
							.cornerRadius(8)
							.shadow(radius: 4)
						
						// Go Button
						Button(action: {
							coordinator.drawRoute(startPoint: startPoint, endPoint: endPoint)
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
