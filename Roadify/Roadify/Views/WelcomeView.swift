//
//  WelcomeView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 14/9/24.
//

import SwiftUI

struct WelcomeView: View {
	@State private var currentPage = 0
	let totalPage = 3
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				if currentPage < totalPage - 1 {
					Button(action: {
						currentPage = totalPage - 1
					}) {
						Text("Skip")
							.foregroundColor(Color("Secondary"))
							.bold()
							.padding([.top, .trailing], 35)
					}
				}
			}
			
			Spacer()
			
			PageViewModel(
				image: currentPageImage,
				title: currentPageTitle,
				description: currentPageDescription,
				onNext: nextPage,
				progress: pageProgress, 
				progressColor: ""
			)
			
			HStack(spacing: 10) {
				ForEach(0..<totalPage, id: \.self) { index in
					Button(action: {
						// show current step
						currentPage = index
					}) {
						Circle()
							.frame(width: 10, height: 10)
							.foregroundColor(currentPage == index ? Color("Secondary") : .gray)
							.animation(.easeInOut, value: 5)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
			.padding(.bottom, 20)
			
			Spacer()
			
		}
		.background(Color("Primary"))
		.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
	
	private var currentPageImage: String {
		switch currentPage {
		case 0: return "welcomeview_img1"
		case 1: return "welcomeview_img2"
		case 2: return "welcomeview_img3"
		default: return ""
		}
	}
	
	private var currentPageTitle: String {
		switch currentPage {
		case 0: return "Stay Safe"
		case 1: return "Help the Community"
		case 2: return "Be a Local Guardian"
		default: return ""
		}
	}
	
	private var currentPageDescription: String {
		switch currentPage {
		case 0: return "View real-time accident reports nearby and choose safer routes to avoid delays and danger"
		case 1: return "Report accidents quickly to alert others and contribute to safer roads for everyone"
		case 2: return "Join a network of vigilant drivers working together to make our roads safer"
		default: return ""
		}
	}
	
	private var pageProgress: CGFloat {
		return CGFloat(currentPage + 1) / CGFloat(totalPage)
	}
	
	private func nextPage() {
		if currentPage < totalPage - 1 {
			currentPage += 1
		} else {
			print("User completed all welcome screens")
		}
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView()
	}
}
