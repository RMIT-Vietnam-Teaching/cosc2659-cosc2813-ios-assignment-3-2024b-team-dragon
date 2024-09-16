import SwiftUI

struct ActivityLogsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Activity Logs")
                .font(.title2)
                .bold()
            
            // Display activity logs here

            Button(action: {
                // Handle log out from all devices
            }) {
                settingsRow(iconName: "arrow.right.circle", label: "Log Out from All Devices")
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
