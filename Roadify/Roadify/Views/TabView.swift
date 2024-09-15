//
//  MapView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 11/9/24.
//

import Foundation
import SwiftUI

struct TabView: View {
	@State private var selectedTab = 0
	@State private var showWelcomeView = true // First launch
	
	var body: some View {
		VStack(spacing: 0) {
			if showWelcomeView {
				WelcomeView(onDismiss: {
					showWelcomeView = false
				})
			} else {
				// Normal Tab View for the app
				VStack(spacing: 0) {
					switch selectedTab {
					case 0:
						MapView()
					case 1:
						NewsView()
					case 2:
						MapView()
					case 3:
						AccountView()
					default:
						Text("Invalid tab")
					}
					
					HStack {
						TabButtonView(viewIsSelected: "map_on", viewIsNotSelected: "map_off", isSelected: selectedTab == 0) {
							selectedTab = 0
						}
						
						TabButtonView(viewIsSelected: "news_on", viewIsNotSelected: "news_off", isSelected: selectedTab == 1) {
							selectedTab = 1
						}
						
						TabButtonView(viewIsSelected: "alert_on", viewIsNotSelected: "alert_off", isSelected: selectedTab == 2) {
							selectedTab = 2
						}
						
						TabButtonView(viewIsSelected: "user_on", viewIsNotSelected: "user_off", isSelected: selectedTab == 3) {
							selectedTab = 3
						}
					}
					.padding()
					.background(Color("Primary"))
				}
				.edgesIgnoringSafeArea(.bottom)
			}
		}
		.onAppear {
			checkFirstLaunch()
		}
	}
	
	func checkFirstLaunch() {
		let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
		if hasLaunchedBefore {
			showWelcomeView = false
		} else {
			UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
			showWelcomeView = true
		}
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		TabView()
	}
}
