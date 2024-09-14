//
//  NewsView.swift
//  Roadify
//
//  Created by Lê Phước on 14/9/24.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var firebaseService = FirebaseService()
    @State private var newsArticles: [News] = []
    @State private var showAddNewsForm = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("News")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    List(newsArticles) { article in
                        NavigationLink(destination: DetailNewsView(newsArticle: article)) {
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: article.imageName)) { image in
                                    image.resizable().frame(width: 60, height: 60).cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                                
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
                        .listRowBackground(Color.black)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    
                    Spacer()
                    
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
                .onAppear {
                    fetchNewsFromFirebase()  // Fetch the news from Firebase when the view appears
                }
                .sheet(isPresented: $showAddNewsForm, onDismiss: {
                    fetchNewsFromFirebase()  // Reload the news when the form is dismissed
                }) {
                    AddNewsFormView()
                }
                .navigationBarItems(trailing: Button(action: {
                    showAddNewsForm = true
                }) {
                    Image(systemName: "plus").foregroundColor(.white)
                })
            }
        }
    }

    private func fetchNewsFromFirebase() {
        firebaseService.fetchNews { result in
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
