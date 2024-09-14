//
//  News.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import Foundation

struct News: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var category: String
    var description: String
    var imageName: String  // This will hold the image URL after Firebase Storage upload
    
    // Firebase convenience initializer
    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let category = data["category"] as? String,
              let description = data["description"] as? String,
              let imageName = data["imageName"] as? String else { return nil }
        
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.imageName = imageName
    }
    
    // Default initializer for creating News locally
    init(title: String, category: String, description: String, imageName: String) {
        self.title = title
        self.category = category
        self.description = description
        self.imageName = imageName
    }
    
    // Convert News object to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "category": category,
            "description": description,
            "imageName": imageName
        ]
    }
}
