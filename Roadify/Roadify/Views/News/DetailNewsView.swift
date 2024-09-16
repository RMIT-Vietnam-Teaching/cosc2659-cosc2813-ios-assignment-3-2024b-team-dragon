//
//  DetailNewsView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct DetailNewsView: View {
    let newsArticle: News  // Use News model instead of NewsArticle

    var body: some View {
        VStack {
            Text(newsArticle.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("SubColor"))
                .padding()
            
            // Load image from the URL stored in Firebase using AsyncImage
            AsyncImage(url: URL(string: newsArticle.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Placeholder while loading the image
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            Text(newsArticle.description)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background
        .navigationBarTitle("", displayMode: .inline)
    }
}
