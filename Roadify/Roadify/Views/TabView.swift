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
	
	var body: some View {
		VStack {
			switch selectedTab {
				// Replacing with Views later on
			case 0:
				ContentView()
			case 1:
				VStack {
					Button("News View") {
						print("Switch to NewsView")
					}
					.padding()
				}
			case 2:
				VStack {
					Button("Alert View") {
						print("Switch to AlertView")
					}
					.padding()
				}
			case 3:
				VStack {
					Button("Profile View") {
						print("Switch to ProfileView")
					}
					.padding()
				}
			default:
				Text("Invalid tab")
			}
			
			Spacer()

			HStack {
				// MapsView
				TabButtonView(viewIsSelected: "map_on", viewIsNotSelected: "map_off", isSelected: selectedTab == 0) {
					selectedTab = 0
				}
				
				// NewsView
				TabButtonView(viewIsSelected: "news_on", viewIsNotSelected: "news_off", isSelected: selectedTab == 1) {
					selectedTab = 1
				}
				
				// AlertView
				TabButtonView(viewIsSelected: "alert_on", viewIsNotSelected: "alert_off", isSelected: selectedTab == 2) {
					selectedTab = 2
				}
				
				// ProfileView
				TabButtonView(viewIsSelected: "user_on", viewIsNotSelected: "user_off", isSelected: selectedTab == 3) {
					selectedTab = 3
				}
			}
			.padding()
			.background(Color.primary)
			.frame(height: 80)
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		TabView()
	}
}
