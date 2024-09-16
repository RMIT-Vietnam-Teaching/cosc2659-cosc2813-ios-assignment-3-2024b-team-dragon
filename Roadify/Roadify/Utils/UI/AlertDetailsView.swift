import SwiftUI

struct AlertDetailsView: View {
    var pin: Pin
    
    var body: some View {
        VStack {
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
            
            Text(pin.title)
                .font(.title)
                .padding(.top, 20)
            
            Text(pin.description)
                .font(.body)
                .padding(.top, 10)
            
            HStack {
                Text("Status: \(pin.status.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Date(), formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Alert Details")
    }
    
    // Date formatter for the alert's timestamp
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}



