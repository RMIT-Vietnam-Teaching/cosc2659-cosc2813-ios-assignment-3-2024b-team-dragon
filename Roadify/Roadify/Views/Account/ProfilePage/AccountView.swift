//
//  AccountView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @AppStorage("appLanguage") var appLanguage: String = "en"  // Store app language
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
    @State private var selectedTab: Int = 3 // Set to 3 for AccountView


    var body: some View {
        VStack(spacing: 20) {
            Text(LocalizedStringKey("profile_title"))
                .font(.title2)
                .bold()

            Spacer()

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
            }

            // Admin Panel Button (conditionally visible based on isAdmin in ViewModel)
            if viewModel.isAdmin {
                Button(action: {
                    showAdminPanelView = true  // Show the Admin Panel when button is tapped
                }) {
                    HStack {
                        Image(systemName: "person.crop.square")
                            .foregroundColor(.green)
                        Text("Admin Panel")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                }
                .sheet(isPresented: $showAdminPanelView) {  // Present the Admin Panel
                    AdminPanelView()
                }
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
                }

                Button(action: {
                    showPrivacyView = true
                }) {
                    SettingsRow(iconName: "lock.shield", label: NSLocalizedString("privacy", comment: ""))
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
                    LanguageSelectionView(
                        selectedLanguage: $selectedLanguage,
                        selectedLanguageFlag: $selectedLanguageFlag)
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
                }

                Button(action: {
                    showReportBugView = true
                }) {
                    SettingsRow(iconName: "flag", label: NSLocalizedString("report_bug", comment: ""))
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
                NavigationLink(destination: TabView(selectedTab: $selectedTab), isActive: $isNavigating) {
                    EmptyView()
                }
                .hidden()  // Hide the NavigationLink
            )

            Spacer()
        }
        .onAppear {
            setLanguageBasedOnAppLanguage()
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of the ViewModel with admin privileges
        let viewModel = AccountViewModel()
        viewModel.isAdmin = true  // Set admin status to true for preview

        return AccountView(viewModel: viewModel)
    }
}
