//
//  HelpView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 19/9/24.
//

import Foundation
import SwiftUI

struct HelpView: View {
	@AppStorage("appLanguage") private var appLanguage: String = "en"
	
	var body: some View {
		VStack {
			Text(LocalizedStringKey("help_center_title"))
				.font(.title2)
				.bold()
				.padding(.top)
			
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					Text(LocalizedStringKey("help_center_description"))
						.font(.body)
					
					// Add more help content or FAQs here
					Text(LocalizedStringKey("faq1"))
						.font(.headline)
					Text(LocalizedStringKey("faq1_answer"))
						.font(.body)
					
					Text(LocalizedStringKey("faq2"))
						.font(.headline)
					Text(LocalizedStringKey("faq2_answer"))
						.font(.body)
					
					// Add additional FAQs as needed
				}
				.padding()
			}
			
			Spacer()
		}
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
	}
}

struct HelpView_Previews: PreviewProvider {
	static var previews: some View {
		HelpView()
	}
}
