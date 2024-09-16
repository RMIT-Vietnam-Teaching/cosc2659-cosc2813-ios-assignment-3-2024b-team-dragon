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
		VStack (spacing: 0) {
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
			.background(Color("Primary"))
		}
		.padding(.bottom)
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		TabView()
	}
}
