import SwiftUI

struct AlertView: View {
    @ObservedObject var viewModel = AlertViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let location = viewModel.userLocation {
                    Text("Your current location: \(location.latitude), \(location.longitude)")
                        .font(.footnote)
                        .padding()
                } else {
                    Text("Retrieving location...")
                        .font(.footnote)
                        .padding()
                }

                List(viewModel.pins) { pin in
                    NavigationLink(destination: AlertDetailsView(pin: pin)) {
                        HStack {
                            Image(systemName: "map")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                            VStack(alignment: .leading) {
                                Text(pin.title)
                                    .font(.headline)
                                Text(pin.description)
                                    .font(.subheadline)
                                
                                // Display the distance
                                if viewModel.userLocation != nil {
                                    Text("\(String(format: "%.1f", viewModel.calculateDistance(pin: pin))) km")
                                        .font(.footnote)
                                        .foregroundColor(.green)
                                } else {
                                    Text("Calculating distance...")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alerts")
            .onAppear {
                viewModel.fetchPins()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
