import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("My Profile")
                .font(.title2)
                .bold()
            
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("Peter Aduku")
                        .font(.headline)
                    Text("babydriver@email.com")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            
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
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
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
                // Action for Logout
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.red)
                    Text("Log out")
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

