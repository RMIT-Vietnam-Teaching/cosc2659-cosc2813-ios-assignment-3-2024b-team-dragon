/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement:
 */

import SwiftUI

struct DetailNewsView: View {
    let newsArticle: News

    var body: some View {
        VStack {
            Text(newsArticle.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("SubColor"))
				.padding(.top, 120)
				.padding(.horizontal)
			
            AsyncImage(url: URL(string: newsArticle.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
					.frame(maxWidth: .infinity)
					.clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            Text(newsArticle.description)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color("MainColor"))
		.edgesIgnoringSafeArea(.all)
		.navigationBarTitle("", displayMode: .inline)
    }
}
