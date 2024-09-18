import SwiftUI

struct AlertDetailsView: View {
    var pin: Pin
    
    var body: some View {
        VStack(spacing: 20) {
            // Title Section
            VStack {
                Text("Alerts")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.top, 10)
                
                Text("\(pin.title)")
                    .font(.headline)
                    .foregroundColor(Color.white)
                
                // Add data timestamp here
                Text("9:41 05/09")
                    .font(.subheadline)
                    .foregroundColor(Color.white)
            }
            .padding(.bottom, 10)
            
            // Image Section
            if let imageUrl = pin.imageUrls.first, !imageUrl.isEmpty {
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
            
            // Thumbs up and down section
            HStack(spacing: 20) {
                HStack {
                    Text("34")
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("2")
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 10)
            
            // Statuses and information section
            VStack(alignment: .leading, spacing: 5) {
                Text("No casualties")
                    .font(.body)
                    .foregroundColor(.white)
                
                Text("Slow traffic")
                    .font(.body)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            
            // Add comment button
            Button(action: {
                // Add comment action here
            }) {
                Text("Add comment")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))  // Set background color
        .navigationBarTitleDisplayMode(.inline)  // Set inline navigation

    }
}

//// Preview with a mock Pin object
//struct AlertDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockPin = Pin(
//            id: "1",
//            latitude: 10.762622,
//            longitude: 106.660172,
//            title: "Two Cars Crash At The Cross Road",
//            description: "No casualties, slow traffic.",
//            status: .verified,
//            imageUrls: ["https://via.placeholder.com/300"]
//        )
//        AlertDetailsView(pin: mockPin)
//    }
//}
