import Foundation
import CoreLocation

struct Marker: Identifiable {
    var id: String
    var title: String
    var coordinate: CLLocationCoordinate2D

    init(id: String, title: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
    }

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        let latitude = data["latitude"] as? Double ?? 0
        let longitude = data["longitude"] as? Double ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
    }
}
