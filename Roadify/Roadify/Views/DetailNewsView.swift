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
            Image(newsArticle.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(newsArticle.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding()
            Text(newsArticle.description)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct DetailNewsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailNewsView(newsArticle: News.sampleNews[0])  // Pass a sample news item
    }
}
