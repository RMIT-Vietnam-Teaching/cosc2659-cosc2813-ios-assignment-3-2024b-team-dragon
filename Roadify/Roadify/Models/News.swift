import Foundation

struct News {
    var id: String
    var title: String
    var image: String // Define image as String to hold URL
    var description: String
    
    init(id: String, title: String, image: String, description: String) {
        self.id = id
        self.title = title
        self.image = image
        self.description = description
    }

    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.image = data["image"] as? String ?? "" 
        self.description = data["description"] as? String ?? ""
    }

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "image": image,
            "description": description
        ]
    }
}
