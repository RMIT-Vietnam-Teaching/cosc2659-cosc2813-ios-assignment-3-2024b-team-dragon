import SwiftUI

struct NewsView: View {
	@StateObject private var newsService = NewsService()
	@State private var newsArticles: [News] = []
	@State private var showAddNewsForm = false
	
	var body: some View {
		NavigationView {
			ZStack (alignment: .bottom){
				VStack (spacing: 0) {
					Text("News")
						.font(.system(size: 28, weight: .bold))
						.foregroundColor(.white)
						.padding()
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
										.padding(.trailing, 20)
									Text(article.category)
										.font(.system(size: 14))
										.foregroundColor(.white)
										.padding(.top, 4)
								}
							}
						}
						.listRowBackground(Color("MainColor"))
						.listRowSeparator(.hidden)
					}
					.listStyle(PlainListStyle())
					.background(Color("MainColor"))
					.edgesIgnoringSafeArea(.all)
				}
				.onAppear {
					fetchNewsFromFirebase()  // Fetch news on view appearance
				}
				// AddNewsFormView appears as an overlay when showAddNewsForm is true
				if showAddNewsForm {
					VStack {
						Spacer()
						AddNewsFormView(showModal: $showAddNewsForm) {
							fetchNewsFromFirebase()  // Refresh the news list after adding new news
						}
						.background(Color("MainColor"))
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
						.padding([.trailing, .bottom], 30)
					}
				}
			}
		}
		.background(Color("MainColor")
			.edgesIgnoringSafeArea(.all))
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
