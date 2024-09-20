//
//  NewsView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct NewsView: View {
	@StateObject private var newsService = NewsService()
	@State private var newsArticles: [News] = []
	@State private var showAddNewsForm = false
	
	var body: some View {
		NavigationView {
			VStack (spacing: 0) {
				Text("News")
					.font(.system(size: 28, weight: .bold))
					.foregroundColor(.white)
					.padding(.top, 16)
					.frame(maxWidth: .infinity, minHeight: 60)
					.background(Color("MainColor"))
				
				List(newsArticles) { article in
					NavigationLink(destination: DetailNewsView(newsArticle: article)) {
						HStack(spacing: 16) {
							// Larger image with rounded corners
							AsyncImage(url: URL(string: article.imageName)) { image in
								image.resizable()
									.scaledToFill()
									.frame(width: 80, height: 80)
									.cornerRadius(12)
									.padding(.leading, 10)
									.clipped()
							} placeholder: {
								ProgressView()
							}
							
							VStack(alignment: .leading, spacing: 4) {
								// Stylized Title
								Text(article.title)
									.font(.system(size: 18, weight: .semibold))
									.foregroundColor(Color("SubColor"))
									.lineLimit(2)
									.truncationMode(.tail)
								
								Text(article.category)
									.font(.system(size: 14))
									.foregroundColor(.white)
									.padding(.top, 4)
							}
							.background(Color("MainColor"))
						}
					}
					.listRowBackground(Color("MainColor"))
					.listRowSeparatorTint(Color("SubColor"))
				}
				.background(Color("MainColor"))
				
				// AddNewsFormView appears as an overlay when showAddNewsForm is true
				if showAddNewsForm {
					VStack {
						AddNewsFormView(showModal: $showAddNewsForm) {
							fetchNewsFromFirebase()  // Refresh the news list after adding new news
						}
						.background(Color("MainColor"))
						.cornerRadius(20)
						.padding(.bottom)
						.transition(.move(edge: .bottom))
					}
				}
				
				// Plus button to trigger the form
				if !showAddNewsForm {
					HStack {
						Spacer()
						Button(action: {
							withAnimation {
								showAddNewsForm = true
							}
						}) {
							Image(systemName: "plus.circle.fill")
								.resizable()
								.frame(width: 50, height: 50)
								.foregroundColor(Color("SubColor"))
								.background(Color("MainColor"))
								.clipShape(Circle())
								.shadow(radius: 5)
						}
						.padding(.trailing, 30)
					}
					.background(Color("MainColor"))
				}
			}
			.onAppear {
				fetchNewsFromFirebase()  // Fetch news on view appearance
			}
		}
	}
	
	private func fetchNewsFromFirebase() {
		newsService.fetchNews { result in
			switch result {
			case .success(let fetchedNews):
				self.newsArticles = fetchedNews
			case .failure(let error):
				print("Error fetching news: \(error.localizedDescription)")
			}
		}
	}
}

struct NewsView_Previews: PreviewProvider {
	static var previews: some View {
		NewsView()
	}
}
