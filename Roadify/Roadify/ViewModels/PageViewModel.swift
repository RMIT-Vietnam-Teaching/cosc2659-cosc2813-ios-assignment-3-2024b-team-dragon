import Foundation
import SwiftUI

struct PageViewModel: View {
	var image: String
	var title: String
	var description: String
	var onNext: () -> Void  // Closure for button action
	var progress: CGFloat
	var progressColor: String
	
	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			
			Image(image)
				.resizable()
				.scaledToFit()
				.frame(height: 300)
				.cornerRadius(10)
				.padding()
			
			Text(title)
				.foregroundColor(Color.white)
				.font(.largeTitle)
				.bold()
				.multilineTextAlignment(.center)
				.padding(.horizontal)
			
			Text(description)
				.foregroundColor(Color.white)
				.font(.title3)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 30)
			
			Spacer()
			
			ZStack {
				let progressColor = progress == 1 ? Color("SubColor") : Color.white
				
				Circle()
					.stroke(Color.gray.opacity(0.3), lineWidth: 3)
					.frame(width: 50, height: 50)
				
				Circle()
					.trim(from: 0, to: progress)
					.stroke(progressColor, lineWidth: 3)
					.rotationEffect(.degrees(-90))
					.frame(width: 50, height: 50)
				
				Button(action: onNext) {
					Image(systemName: "arrow.right.circle.fill")
						.font(.system(size: 30))
						.foregroundColor(progressColor)
					
				}
				.padding()
			}
			.padding()
			.background(Color("MainColor"))
		}
	}
}
