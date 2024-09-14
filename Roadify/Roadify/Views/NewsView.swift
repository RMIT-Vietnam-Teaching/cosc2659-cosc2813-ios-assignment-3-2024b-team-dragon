//
//  NewsView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct NewsView: View {
    let newsArticles: [News] = News.sampleNews  // Use News model instead of NewsArticle

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Background of the whole view
                
                VStack {
                    // Custom title at the top of the view
                    Text("News")
                        .font(.system(size: 28, weight: .bold))  // Bold and large font size for the title
                        .foregroundColor(.white)
                        .padding(.top, 16) // Adjust padding based on design
                    
                    // News list view
                    List(newsArticles) { article in
                        NavigationLink(destination: DetailNewsView(newsArticle: article)) {
                            HStack(spacing: 16) {
                                Image(article.imageName)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(article.title)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(article.category)
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.black) // Each row background color
                    }
                    .scrollContentBackground(.hidden) // Remove the default background of the list
                    .background(Color.black) // Set list background color
                    
                    Spacer()
                    
                    // Footer view (similar to your screenshot)
                    VStack {
                        Text("Today, 10 accidents have been reported on")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text("ROAD!FY")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("") // Empty to hide the default title bar
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
