import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel = AccountViewModel() // Use AccountViewModel
    @State private var showEditProfile = false
    @State private var showPrivacyView = false
    @State private var showNotificationsView = false
    @State private var showLanguageView = false
    @State private var selectedLanguage = "English"
    @State private var selectedLanguageFlag = "us"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Profile")
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
            Section(header: Text("Settings and Preferences").font(.subheadline)) {
                Button(action: {
                    showNotificationsView = true
                }) {
                    settingsRow(iconName: "bell", label: "Notifications")
                }
                .sheet(isPresented: $showNotificationsView) {
                    NotificationsView() // Placeholder for actual view
                }
                
                Button(action: {
                    showPrivacyView = true
                }) {
                    settingsRow(iconName: "lock.shield", label: "Privacy")
                }
                .sheet(isPresented: $showPrivacyView) {
                    PrivacyView() // PrivacyView containing Change Password
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
            Section(header: Text("Support").font(.subheadline)) {
                settingsRow(iconName: "questionmark.circle", label: "Help centre")
                settingsRow(iconName: "flag", label: "Report a bug")
            }
            
            // Log out
            Button(action: {
                viewModel.logOut()
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.red)
                    Text("Log out")
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color("PrimaryColor").edgesIgnoringSafeArea(.all))
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
    
    private func languageRow(language: String, flag: String) -> some View {
        HStack {
            Image(flag) // Display the flag image
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
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    @Binding var selectedLanguageFlag: String
    
    var body: some View {
        VStack {
            Text("Select Language")
                .font(.title2)
                .bold()
                .padding(.top)
            
            Button(action: {
                selectedLanguage = "English"
                selectedLanguageFlag = "us"
            }) {
                languageRow(language: "English", flag: "us")
            }
            
            Button(action: {
                selectedLanguage = "Vietnamese"
                selectedLanguageFlag = "vn"
            }) {
                languageRow(language: "Vietnamese", flag: "vn")
            }
            
            Spacer()
        }
        .padding()
        .background(Color("PrimaryColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private func languageRow(language: String, flag: String) -> some View {
        HStack {
            Image(flag)
                .resizable()
                .frame(width: 24, height: 24)
            Text(language)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
