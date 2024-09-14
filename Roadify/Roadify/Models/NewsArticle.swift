//
//  NewsArticle.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import Foundation

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let description: String
    let imageName: String
}
