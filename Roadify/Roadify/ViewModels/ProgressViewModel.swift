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
