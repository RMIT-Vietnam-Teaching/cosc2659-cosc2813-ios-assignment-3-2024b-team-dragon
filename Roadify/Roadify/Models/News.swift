//
//  News.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import Foundation

struct News: Identifiable {
    var id = UUID().uuidString
    var title: String
    var category: String
    var description: String
    var imageName: String  // Image file name to be used in SwiftUI
    
    static let sampleNews = [
        News(
            title: "Ho Chi Minh City opens $16mm extended street section to traffic",
            category: "Society",
            description: "The extended section of Nguyen Van Linh Boulevard...",
            imageName: "news_image_1"
        ),
        News(
            title: "Gojek to withdraw from Vietnam in mid-September",
            category: "Business",
            description: "Ride-hailing giant Gojek will exit the Vietnam market...",
            imageName: "news_image_2"
        ),
        News(
            title: "Free-roaming cows in Da Nang's industrial park cause traffic hazards",
            category: "Society",
            description: "Cows roaming freely on major roads in Hoa Khanh Industrial Park...",
            imageName: "news_image_3"
        ),
        News(
            title: "Meet the night traffic rescue team in southern Vietnam",
            category: "Society",
            description: "A group of volunteers working through the night...",
            imageName: "news_image_4"
        )
    ]
}
