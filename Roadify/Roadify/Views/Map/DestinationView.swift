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

struct DestinationView: View {
	@Binding var destinationAddress: String
	@Binding var showRoutingView: Bool
	
	var body: some View {
		VStack {
			Spacer().frame(height: 15)
			HStack {
				Text(NSLocalizedString("destination", comment: ""))
					.font(.system(size: 18, weight: .bold, design: .default))
					.foregroundStyle(Color.white)
					.padding([.top, .bottom], 10)
				Spacer()
			}
			.padding(.leading)
			
			HStack {
				TextField(NSLocalizedString("destination_textfield", comment: ""), text: $destinationAddress)
					.padding()
					.background(Color.white)
					.cornerRadius(10)
					.shadow(radius: 4)
					.padding([.bottom, .trailing, .leading])
					.onTapGesture {
						showRoutingView = true
					}
					.disabled(true)
			}
		}
		.background(Color("MainColor"))
		.cornerRadius(15)
		.padding()
		.shadow(radius: 5)
	}
}

struct DestinationView_Previews: PreviewProvider {
	static var previews: some View {
		DestinationView(destinationAddress: .constant(""), showRoutingView: .constant(false))
	}
}
