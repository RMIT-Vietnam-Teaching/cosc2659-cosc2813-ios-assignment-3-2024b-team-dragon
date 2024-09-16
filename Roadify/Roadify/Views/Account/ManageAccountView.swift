import SwiftUI

struct ManageAccountDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Manage Account Data")
                .font(.title2)
                .bold()
            
            Button(action: {
                // Handle data download request
            }) {
                settingsRow(iconName: "arrow.down.circle", label: "Download Data")
            }
            
            Button(action: {
                // Handle account deletion
            }) {
                settingsRow(iconName: "trash", label: "Delete Account")
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
