//
//  TermsOfServiceView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct TermsOfServiceView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				Text("Terms of Service")
					.font(.title)
					.bold()
					.padding(.top)
				
				// Example Terms of Service content
				Text("""
				Welcome to our application. By using our app, you agree to the following terms of service:
				
				1. **Acceptance of Terms**: By accessing or using our application, you agree to be bound by these terms.
				
				2. **User Responsibilities**: You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.
				
				3. **Prohibited Activities**: You agree not to engage in any illegal or unauthorized activities when using our app.
				
				4. **Termination**: We reserve the right to terminate your access to our app if you violate these terms.
				
				5. **Changes to Terms**: We may update these terms from time to time. Any changes will be posted in this section.
				
				For more information or if you have any questions, please contact us at roadify911@gmail.com.
				""")
				.padding(.horizontal)
				
				Spacer()
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
		}
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
	}
}

struct TermsOfServiceView_Previews: PreviewProvider {
	static var previews: some View {
		TermsOfServiceView()
	}
}
