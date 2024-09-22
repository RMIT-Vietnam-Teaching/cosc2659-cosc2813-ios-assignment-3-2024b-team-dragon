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

import Foundation
import SwiftUI

struct TabButtonView: View {
	var viewIsSelected: String
	var viewIsNotSelected: String
	var isSelected: Bool
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack {
				if isSelected {
					Image(viewIsSelected)
						.resizable()
						.frame(width: 25, height: 25)
					Circle()
						.frame(width: 4, height: 4)
						.foregroundColor(Color("SubColor"))
				} else {
					Image(viewIsNotSelected)
						.resizable()
						.frame(width: 25, height: 25)
				}
			}
		}
		.frame(maxWidth: .infinity)
	}
}
