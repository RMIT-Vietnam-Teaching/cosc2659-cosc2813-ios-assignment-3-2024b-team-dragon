/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import SwiftUI

struct ProgressViewModel: ProgressViewStyle {
	var color: Color
	var textColor: Color = .primary  
	var text: String
	
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			Spacer()
			VStack {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: color))
				Text(text)
					.foregroundColor(textColor)
					.padding(.top, 8)
			}
			Spacer()
		}
	}
}
