import SwiftUI
import CoreLocation

struct CRUDView: View {
    @StateObject private var firebaseService = FirebaseService()
    @State private var markers: [Marker] = []
    @State private var title: String = ""
    @State private var selectedMarker: Marker?
    
    var body: some View {
        VStack {
            TextField("Marker Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                let newMarker = Marker(id: UUID().uuidString, title: title, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
                firebaseService.addMarker(marker: newMarker) { error in
                    if error == nil {
                        title = ""
                    }
                }
            }) {
                Text("Add Marker")
            }
            .padding()
            
            List {
                ForEach(markers) { marker in
                    HStack {
                        Text(marker.title)
                        Spacer()
                        Button(action: {
                            selectedMarker = marker
                            title = marker.title
                        }) {
                            Text("Edit")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button(action: {
                            firebaseService.deleteMarker(markerId: marker.id) { error in
                                if error == nil {
                                    fetchMarkers() // Refresh the list after deletion
                                }
                            }
                        }) {
                            Text("Delete")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            firebaseService.fetchMarkers { result in
                switch result {
                case .success(let fetchedMarkers):
                    markers = fetchedMarkers
                case .failure(let error):
                    print("Error fetching markers: \(error.localizedDescription)")
                }
            }
        }
        .alert(item: $selectedMarker) { marker in
            Alert(title: Text("Edit Marker"), message: Text("Update the marker title"), primaryButton: .default(Text("Update")) {
                if let index = markers.firstIndex(where: { $0.id == marker.id }) {
                    markers[index].title = title
                    firebaseService.updateMarker(marker: markers[index]) { error in
                        if error == nil {
                            title = ""
                            selectedMarker = nil
                        }
                    }
                }
            }, secondaryButton: .cancel())
        }
    }
}

struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}
