import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel = AccountViewModel() // Use AccountViewModel
    @State private var showEditProfile = false

    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Profile")
                .font(.title2)
                .bold()
            
            Button(action: {
                // Navigate to EditProfileView
                showEditProfile = true
            }) {
                HStack {
                    // If profileImageUrl is available, load the image from URL
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
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 96/255, green: 100/255, blue: 105/255).opacity(0.1)))            }
            .sheet(isPresented: $showEditProfile) {
                // Present EditProfileView
                EditProfileView(viewModel: viewModel)
            }
            
            // Referrals and rewards
            Button(action: {
                // Action for Referrals and Rewards
            }) {
                HStack {
                    Image(systemName: "gift")
                        .foregroundColor(.green)
                    Text("Referrals and rewards")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 96/255, green: 100/255, blue: 105/255).opacity(0.5)))
            }
            
            // Settings and Preferences
            Section(header: Text("Settings and Preferences").font(.subheadline)) {
                settingsRow(iconName: "bell", label: "Notifications")
                settingsRow(iconName: "globe", label: "Language")
                settingsRow(iconName: "lock.shield", label: "Security")
            }
            
            // Support
            Section(header: Text("Support").font(.subheadline)) {
                settingsRow(iconName: "questionmark.circle", label: "Help centre")
                settingsRow(iconName: "flag", label: "Report a bug")
            }
            
            // Log out
            Button(action: {
                viewModel.logOut() // Log out action using ViewModel
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
        .background(Color(red: 28/255, green: 33/255, blue: 41/255).edgesIgnoringSafeArea(.all))
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
        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 96/255, green: 100/255, blue: 105/255).opacity(0.5)))
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
