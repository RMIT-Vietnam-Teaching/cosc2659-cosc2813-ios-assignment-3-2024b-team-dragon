//
//  DetailNewsView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct DetailNewsView: View {
    let newsArticle: NewsArticle

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Background color

            ScrollView {
                VStack(alignment: .leading) {
                    // News Image
                    Image(newsArticle.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding(.bottom, 16)

                    // News Title
                    Text(newsArticle.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)

                    // News Description
                    Text(newsArticle.description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)

                    // Add more detailed text or information here...
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}
