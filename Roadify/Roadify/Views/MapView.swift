//
//  MapView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 11/9/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct MapView: View {
	@State private var selectedTab = 0
	
	var body: some View {
		VStack {
			switch selectedTab {
			case 0:
				VStack {
					Button("Button 1") {
						print("Button 1 Pressed")
					}
					.padding()
				}
			case 1:
				VStack {
					Button("Button 2") {
						print("Button 2 Pressed")
					}
					.padding()
				}
			case 2:
				VStack {
					Button("Button 3") {
						print("Button 3 Pressed")
					}
					.padding()
				}
			case 3:
				VStack {
					Button("Button 4") {
						print("Button 4 Pressed")
					}
					.padding()
				}
			default:
				Text("Invalid tab")
			}
			
			Spacer()

			HStack {
				Button(action: { selectedTab = 0 }) {
					VStack {
						if (selectedTab == 0) {
							Image("map_on")
								.resizable()
								.frame(width: 25, height: 25)
							Circle()
								.frame(width: 6, height: 6)
								.foregroundColor(Color("Secondary"))
						} else {
							Image("map_off")
								.resizable()
								.frame(width: 25, height: 25)
						}
					}
				}
				.frame(maxWidth: .infinity)
				
				Button(action: { selectedTab = 1 }) {
					VStack {
						if (selectedTab == 1) {
							Image("news_on")
								.resizable()
								.frame(width: 25, height: 25)
							Circle()
								.frame(width: 6, height: 6)
								.foregroundColor(Color("Secondary"))
						} else {
							Image("news_off")
								.resizable()
								.frame(width: 25, height: 25)
						}
					}
				}
				.frame(maxWidth: .infinity)
				
				Button(action: { selectedTab = 2 }) {
					VStack {
						if (selectedTab == 2) {
							Image("alert_on")
								.resizable()
								.frame(width: 25, height: 25)
							Circle()
								.frame(width: 6, height: 6)
								.foregroundColor(Color("Secondary"))
						} else {
							Image("alert_off")
								.resizable()
								.frame(width: 25, height: 25)
						}
					}
				}
				.frame(maxWidth: .infinity)
				
				Button(action: { selectedTab = 3 }) {
					VStack {
						if (selectedTab == 3) {
							Image("user_on")
								.resizable()
								.frame(width: 25, height: 25)
							Circle()
								.frame(width: 6, height: 6)
								.foregroundColor(Color("Secondary"))
						} else {
							Image("user_off")
								.resizable()
								.frame(width: 25, height: 25)
						}
					}
				}
				.frame(maxWidth: .infinity)
			}
			.padding()
			.background(Color.primary)
			.frame(height: 80)
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
