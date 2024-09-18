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
            ZStack {
                // Main content: Background and list of news articles
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    // Custom title for the view
                    Text("News")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("SubColor"))
                        .padding(.top, 16)

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
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("ThirdColor"), lineWidth: 1)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(15)
                            )
                        }
                        .listRowBackground(Color.black)
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)

                    Spacer()
                }
                .onAppear {
                    fetchNewsFromFirebase()  // Fetch news on view appearance
                }

                // AddNewsFormView appears as an overlay when showAddNewsForm is true
                if showAddNewsForm {
                    // Use a full-screen overlay to prevent interaction with the news articles
                    Color.black.opacity(0.5) // Semi-transparent background to dim the list
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity) // Transition effect for fade in

                    VStack {
                        Spacer()
                        AddNewsFormView(showModal: $showAddNewsForm) {
                            fetchNewsFromFirebase()  // Refresh the news list after adding new news
                        }
                        .background(Color("MainColor"))
                        .cornerRadius(20)
                        .padding()
                        .transition(.move(edge: .bottom))
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .zIndex(1) // Ensure the form is always on top
                }

                // Plus button to trigger the form
                if !showAddNewsForm {
                    VStack {
                        Spacer()
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
                                    .background(Color("ThirdColor"))
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding(30)
                        }
                    }
                    .zIndex(0) // Ensure this is behind the form when shown
                }
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
