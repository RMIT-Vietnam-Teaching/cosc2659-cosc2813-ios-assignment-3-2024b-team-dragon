//
//  ReportABugView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 19/9/24.
//

import Foundation
import SwiftUI
import MessageUI

struct ReportABugView: View {
	@AppStorage("appLanguage") private var appLanguage: String = "en"
	@State private var enquiry: String = ""
	@State private var showMailCompose = false
	@State private var result: Result<MFMailComposeResult, Error>? = nil
	
	var body: some View {
		VStack(spacing: 20) {
			Text(NSLocalizedString("report_bug_title", comment: "Title for the report bug view"))
				.font(.title2)
				.bold()
				.padding(.top)
			
			Text(NSLocalizedString("report_bug_description", comment: "Description for the report bug view"))
			
			TextEditor(text: $enquiry)
				.frame(height: 200)
				.padding()
				.background(Color("ThirdColor").opacity(0.1))
				.cornerRadius(10)
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
				.foregroundColor(.black)
			
			Button(action: {
				sendEmail()
			}) {
				Text(NSLocalizedString("submit", comment: "Submit button text"))
					.font(.headline)
					.foregroundColor(.black)
					.padding()
					.background(Color("SubColor"))
					.cornerRadius(10)
			}
			.disabled(enquiry.isEmpty)
			
			Spacer()
		}
		.padding()
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
		.sheet(isPresented: $showMailCompose) {
			MailView(result: $result, enquiry: enquiry)
		}
	}
	
	private func sendEmail() {
		guard MFMailComposeViewController.canSendMail() else {
			// Handle the case where the user cannot send email
			return
		}
		
		showMailCompose = true
	}
}

struct MailView: UIViewControllerRepresentable {
	@Binding var result: Result<MFMailComposeResult, Error>?
	var enquiry: String
	
	func makeUIViewController(context: Context) -> MFMailComposeViewController {
		let mailVC = MFMailComposeViewController()
		mailVC.mailComposeDelegate = context.coordinator
		mailVC.setToRecipients(["roadify911@gmail.com"])
		mailVC.setSubject(NSLocalizedString("user_enquiry_subject", comment: "Subject for the user enquiry email"))
		mailVC.setMessageBody(enquiry, isHTML: false)
		return mailVC
	}
	
	func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(result: $result)
	}
	
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
		@Binding var result: Result<MFMailComposeResult, Error>?
		
		init(result: Binding<Result<MFMailComposeResult, Error>?>) {
			_result = result
		}
		
		func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
			if let error = error {
				self.result = .failure(error)
			} else {
				self.result = .success(result)
			}
			controller.dismiss(animated: true)
		}
	}
}

struct ReportABugView_Previews: PreviewProvider {
	static var previews: some View {
		ReportABugView()
	}
}
