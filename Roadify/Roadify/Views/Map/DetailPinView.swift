import SwiftUI

struct DetailPinView: View {
	@Binding var selectedPin: Pin?
	@Binding var selectedTab: Int
	@Binding var isFromMapView: Bool
	@Binding var isDetailPinViewPresented: Bool
	
    let pin: Pin

    var body: some View {
        VStack(spacing: 0) {
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
						selectedPin = nil
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
				.padding([.top, .trailing], 20)

            }

            // Pin Title and Date
            HStack {
                Text(pin.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(Color("SubColor"))
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(formattedDate(pin.timestamp))
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding([.leading, .trailing], 16)
            .padding(.top, 10)

            // Pin Image Section (if available)
            if let imageUrl = pin.imageUrls.first {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                .padding([.leading, .trailing, .top], 16)
            }
 
            // Buttons Section (Like/Dislike and View in Alert)
            HStack {
                // Like Button
                Button(action: {
                    print("Liked")
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                }
                .padding(.leading, 30)

                Spacer()

                // View in Alert Button
                Button(action: {
					selectedTab = 2
					selectedPin = pin
					isFromMapView = true
					isDetailPinViewPresented = false
				}) {
                    Text("View in Alert")
                        .font(.headline)
                        .padding()
                        .frame(width: 200, height: 45)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }

                Spacer()

                // Dislike Button
                Button(action: {
                    print("Disliked")
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                }
                .padding(.trailing, 30)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
		.background(Color("MainColor"))
		.cornerRadius(15)
		.overlay(
			RoundedRectangle(cornerRadius: 15)
				.stroke(Color.white.opacity(0.2), lineWidth: 2)
		)
		.shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .transition(.move(edge: .bottom))
//        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) 
		.animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: 1)
		.padding()
    }

    // Helper to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailPinView_Previews: PreviewProvider {
    @State static var mockPin = Pin(
        id: UUID().uuidString,
        latitude: 37.7749,
        longitude: -122.4194,
        title: "Two Cars Crash At The Cross Road",
        description: "",
        status: .pending,
        imageUrls: ["https://images.unsplash.com/photo-1571127239461-6364773b2a56"],
        timestamp: Date(),
        reportedBy: "User123"
    )

	@State static var selectedPin: Pin?
	@State static var selectedTab: Int = 0
	@State static var isFromMapView: Bool = false
	@State static var isDetailPinViewPresented: Bool = false
	
	static var previews: some View {
		DetailPinView(selectedPin: .constant(mockPin), selectedTab: $selectedTab, isFromMapView: $isFromMapView, isDetailPinViewPresented: $isDetailPinViewPresented, pin: mockPin)
	}
}
