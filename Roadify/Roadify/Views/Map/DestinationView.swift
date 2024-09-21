import SwiftUI

struct DestinationView: View {
	@Binding var destinationAddress: String
	@Binding var showRoutingView: Bool
	
	var body: some View {
		VStack {
			Spacer().frame(height: 15)
			HStack {
				Text("Where are you going to?")
					.foregroundStyle(Color.white)
				Spacer()
			}
			.padding(.leading)
			
			HStack {
				TextField("Enter destination", text: $destinationAddress)
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
		// Provide sample bindings for preview
		DestinationView(destinationAddress: .constant(""), showRoutingView: .constant(false))
	}
}
