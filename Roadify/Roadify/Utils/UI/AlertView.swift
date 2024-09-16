import SwiftUI
import CoreLocation

struct AlertView: View {
    @ObservedObject var viewModel = AlertViewModel()
    
    var body: some View {
        NavigationView {
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
                            Text("\(String(format: "%.1f", viewModel.calculateDistance(pin: pin))) km")
                                .font(.footnote)
                                .foregroundColor(.green)
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
