//
//  DestinationView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 16/9/24.
//

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
						// End Point¡
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

//
//struct RoutingView_Previews: PreviewProvider {
//	static var previews: some View {
//		RoutingView(startingPoint: .constant("37.7749, -122.4194"),
//					endPoint: .constant("34.0522, -118.2437"))
//	}
//}
