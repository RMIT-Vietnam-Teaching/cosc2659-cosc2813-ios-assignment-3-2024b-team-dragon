//
//  AccountView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
	@AppStorage("appLanguage") var appLanguage: String = "en" // Store app language
	@ObservedObject var viewModel = AccountViewModel()
    @State private var showAlert = false
    @State private var isNavigating = false
	@State private var showEditProfile = false
	@State private var showPrivacyView = false
	@State private var showNotificationsView = false
	@State private var showLanguageView = false
	@State private var showHelpView = false
	@State private var showReportBugView = false
	@State private var selectedLanguage = "English"
	@State private var selectedLanguageFlag = "us"
	
	var body: some View {
		VStack(spacing: 20) {
			Text(LocalizedStringKey("profile_title"))
				.font(.title2)
				.bold()
			            
			Button(action: {
				showEditProfile = true
			}) {
				HStack {
					if let profileImageUrl = URL(string: viewModel.profileImageUrl), !viewModel.profileImageUrl.isEmpty {
						AsyncImage(url: profileImageUrl) { image in
							image
								.resizable()
								.frame(width: 60, height: 60)
								.clipShape(Circle())
						} placeholder: {
							Image(systemName: "person.crop.circle")
								.resizable()
								.frame(width: 60, height: 60)
								.clipShape(Circle())
						}
					} else {
						Image(systemName: "person.crop.circle")
							.resizable()
							.frame(width: 60, height: 60)
							.clipShape(Circle())
					}
					
					VStack(alignment: .leading) {
						Text(viewModel.username)
							.font(.headline)
						Text(viewModel.email)
							.font(.subheadline)
					}
					
					Spacer()
					
					Image(systemName: "chevron.right")
				}
				.padding()
				.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.1)))
			}
			.sheet(isPresented: $showEditProfile) {
				EditProfileView(viewModel: viewModel)
			}
			
			// Settings and Preferences
			Section(header: Text(LocalizedStringKey("settings_preferences")).font(.subheadline)) {
				Button(action: {
					showNotificationsView = true
				}) {
					settingsRow(iconName: "bell", label: LocalizedStringKey("notifications"))
				}
				.sheet(isPresented: $showNotificationsView) {
					NotificationsView()
				}
				
				Button(action: {
					showPrivacyView = true
				}) {
					settingsRow(iconName: "lock.shield", label: LocalizedStringKey("privacy"))
				}
				.sheet(isPresented: $showPrivacyView) {
					PrivacyView()
				}
				
				Button(action: {
					showLanguageView = true
				}) {
					languageRow(language: selectedLanguage, flag: selectedLanguageFlag)
				}
				.sheet(isPresented: $showLanguageView) {
					LanguageSelectionView(selectedLanguage: $selectedLanguage, selectedLanguageFlag: $selectedLanguageFlag)
				}
			}
			
			// Support
			Section(header: Text(LocalizedStringKey("support")).font(.subheadline)) {
				Button(action: {
					showHelpView = true
				}) {
					settingsRow(iconName: "questionmark.circle", label: LocalizedStringKey("help_center"))
				}
				.sheet(isPresented: $showHelpView) {
					HelpView()
				}
				
				Button(action: {
					showReportBugView = true
				}) {
					settingsRow(iconName: "flag", label: LocalizedStringKey("report_bug"))
				}
				.sheet(isPresented: $showReportBugView) {
					ReportABugView()
				}
			}
			
            // Log out Button
            Button(action: {
                showAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.red)
                    Text(LocalizedStringKey("log_out"))
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(LocalizedStringKey("are_you_sure")),
                    message: Text(LocalizedStringKey("are_you_sure_message")),
                    primaryButton: .destructive(Text(LocalizedStringKey("yes"))) {
                        // User confirmed logout
                        viewModel.logOut()
                        isNavigating = true
                    },
                    secondaryButton: .cancel(Text(LocalizedStringKey("no")))
                )
            }
            .background(
                NavigationLink(destination: AccountNotLoginView(), isActive: $isNavigating) {
                    EmptyView()
                }
            )
			
			Spacer()
		}
		.onAppear {
			setLanguageBasedOnAppLanguage()
		}
		.padding()
		.background(Color("MainColor").edgesIgnoringSafeArea(.all))
		.foregroundColor(.white)
	}
	
	private func settingsRow(iconName: String, label: LocalizedStringKey) -> some View {
		HStack {
			Image(systemName: iconName)
			Text(label)
			Spacer()
			Image(systemName: "chevron.right")
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
	}
	
	private func languageRow(language: String, flag: String) -> some View {
		HStack {
			Image(flag)
				.resizable()
				.frame(width: 24, height: 24)
			Text(language)
				.font(.headline)
			Spacer()
			Image(systemName: "chevron.right")
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
	}
	
	// Function to set the initial language and flag based on appLanguage value
	private func setLanguageBasedOnAppLanguage() {
		if appLanguage == "vi" {
			selectedLanguage = "Vietnamese"
			selectedLanguageFlag = "vn"
		} else {
			selectedLanguage = "English"
			selectedLanguageFlag = "us"
		}
	}
}
