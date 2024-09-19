//
//  PrivacyView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct PrivacyView: View {
	@State private var showManageAccountData = false
	@State private var showActivityLogs = false
	@State private var showPrivacyPolicy = false
	@State private var showTermsOfService = false
	@State private var showForgotPasswordView = false
	
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Privacy Settings")
				.font(.title2)
				.bold()
			
			Button(action: {
				showManageAccountData = true
			}) {
				settingsRow(iconName: "doc.text", label: "Manage Account Data")
			}
			.sheet(isPresented: $showManageAccountData) {
				ManageAccountDataView()
			}
			
			Button(action: {
				// Action for changing password
				showForgotPasswordView = true
			}) {
				HStack {
					Image(systemName: "key.fill")
					Text("Change Password")
					Spacer()
					Image(systemName: "chevron.right")
				}
				.padding()
				.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
			}
			.sheet(isPresented: $showForgotPasswordView) {
				ForgotPasswordView() // Navigate to ForgotPasswordView
			}
			
			Button(action: {
				showActivityLogs = true
			}) {
				settingsRow(iconName: "clock", label: "Activity Logs")
			}
			.sheet(isPresented: $showActivityLogs) {
				ActivityLogsView()
			}
			
			Button(action: {
				showPrivacyPolicy = true
			}) {
				settingsRow(iconName: "doc.text.magnifyingglass", label: "Privacy Policy")
			}
			.sheet(isPresented: $showPrivacyPolicy) {
				PrivacyPolicyView()
			}
			
			Button(action: {
				showTermsOfService = true
			}) {
				settingsRow(iconName: "doc.text", label: "Terms of Service")
			}
			.sheet(isPresented: $showTermsOfService) {
				TermsOfServiceView()
			}
			
			Spacer()
		}
		.padding()
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
	}
	
	private func settingsRow(iconName: String, label: String) -> some View {
		HStack {
			Image(systemName: iconName)
			Text(label)
			Spacer()
			Image(systemName: "chevron.right")
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
	}
}

struct PrivacyView_Previews: PreviewProvider {
	static var previews: some View {
		PrivacyView()
	}
}
