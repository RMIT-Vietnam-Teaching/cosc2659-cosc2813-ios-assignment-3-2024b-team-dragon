import SwiftUI

struct AlertView: View {
    @ObservedObject var viewModel = AlertViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title Section
                Text("Alerts")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.top, 20)
                
                // Search Bar
                SearchBar(label: "Search Alerts", text: $viewModel.searchText)
                
                // List of Alerts (Filtered)
                List(viewModel.filteredPins) { pin in
                    NavigationLink(destination: AlertDetailsView(pin: pin)) {
                        HStack {
                            // Map Image (Placeholder)
                            Image("map_on")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(pin.title)
                                    .foregroundColor(Color("SecondaryColor"))
                                    .font(.headline)
                                Text("\(viewModel.calculateDistance(pin: pin), specifier: "%.1f") km")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .listRowBackground(Color("MainColor"))
                }
                .listStyle(PlainListStyle())
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))  // Set background color to match design
            .navigationBarHidden(true)
        }
        .accentColor(Color("SecondaryColor"))
        .onAppear {
            viewModel.fetchPins()
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
