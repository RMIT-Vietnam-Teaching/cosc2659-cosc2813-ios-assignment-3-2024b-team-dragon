/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import SwiftUI

struct AccountView: View {
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = false
    @ObservedObject var viewModel = AccountViewModel()

    @State private var showAlert = false
    @State private var isNavigating = false

    @State private var showEditProfile = false
    @State private var showAdminPanelView = false
    @State private var showPrivacyView = false
    @State private var showNotificationsView = false
    @State private var showLanguageView = false
    @State private var showHelpView = false
    @State private var showReportBugView = false
    @State private var selectedLanguage = "English"
    @State private var selectedLanguageFlag = "us"

    @Binding var selectedPin: Pin?
    @Binding var selectedTab: Int
    @Binding var isFromMapView: Bool

    var body: some View {
        VStack {
            if !viewModel.isAdmin {
                Text(LocalizedStringKey("profile_title"))
                    .font(.title2)
                    .bold()
            }

            Button(action: {
                showEditProfile = true
            }) {
                HStack {
                    if let profileImageUrl = URL(string: viewModel.profileImageUrl),
                       !viewModel.profileImageUrl.isEmpty
                    {
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
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.1)))
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(viewModel: viewModel)
                    .preferredColorScheme(darkModeEnabled ? .dark : .light)
            }

            if viewModel.isAdmin {
                Button(action: {
                    showAdminPanelView = true
                }) {
                    HStack {
                        Image(systemName: "person.crop.square")
                            .foregroundColor(.green)
                        Text(NSLocalizedString("Admin_nav", comment: ""))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                }
                .sheet(isPresented: $showAdminPanelView) {
                    AdminPanelView()
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }
            }

            // Dark/Light Mode Toggle Button
            Button(action: {
                darkModeEnabled.toggle()
            }) {
                HStack {
                    Image(systemName: darkModeEnabled ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(.yellow)
                    Text(darkModeEnabled ? NSLocalizedString("darkMode", comment: "") : NSLocalizedString("lightMode", comment: ""))
					
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.1)))
            }

            // Settings and Preferences
            Section(header: Text(LocalizedStringKey("settings_preferences")).font(.subheadline)) {
                Button(action: {
                    showNotificationsView = true
                }) {
                    SettingsRow(iconName: "bell", label: NSLocalizedString("notifications", comment: ""))
                }
                .sheet(isPresented: $showNotificationsView) {
                    NotificationsView()
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }

                Button(action: {
                    showPrivacyView = true
                }) {
                    SettingsRow(iconName: "lock.shield", label: NSLocalizedString("privacy", comment: ""))
                }
                .sheet(isPresented: $showPrivacyView) {
                    PrivacyView()
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }

                Button(action: {
                    showLanguageView = true
                }) {
                    languageRow(language: selectedLanguage, flag: selectedLanguageFlag)
                }
                .sheet(isPresented: $showLanguageView) {
                    LanguageSelectionView(
                        selectedLanguage: $selectedLanguage,
                        selectedLanguageFlag: $selectedLanguageFlag)
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }
            }

			// Support
			Section(header: Text(LocalizedStringKey("support")).font(.subheadline)) {
				Button(action: {
					showHelpView = true
				}) {
					SettingsRow(
						iconName: "questionmark.circle", label: NSLocalizedString("help_center",comment: ""))
				}
				.sheet(isPresented: $showHelpView) {
					HelpView()
					.preferredColorScheme(darkModeEnabled ? .dark : .light)
				}
				
				Button(action: {
					showReportBugView = true
				}) {
					SettingsRow(iconName: "flag", label: NSLocalizedString("report_bug", comment: ""))
				}
				.sheet(isPresented: $showReportBugView) {
					ReportABugView()
					.preferredColorScheme(darkModeEnabled ? .dark : .light)
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
                .padding([.top, .leading, .bottom])
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

            VStack {
                Spacer(minLength: 15)
                NavigationLink(destination:
                                TabView(selectedPin: $selectedPin,
                                        selectedTab: $selectedTab,
                                        isFromMapView: $isFromMapView),
                               isActive: $isNavigating) {
                }
            }
        }
        .onAppear {
            setLanguageBasedOnAppLanguage()
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
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
