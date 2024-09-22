import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @Environment(\.presentationMode) var presentationMode  // To handle the back button

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Back button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Go back to the previous view
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }

                Spacer()

                // Centered title
                Text("Notifications")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.notifications) { notification in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(notification.title)
                                        .font(.headline)
                                        .foregroundColor(Color("SubColor"))

                                    Text(notification.body)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(notification.timestamp, formatter: notificationDateFormatter)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                // Optional: Add any action button here, like mark as read or delete
                                // Button for delete or mark as read
                            }
                            .padding(.vertical, 8)
                            .background(Color("MainColor").opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)

                            // Add a gray line (divider) below each notification
                            Divider()
                                .background(Color.gray)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    // Formatter for displaying timestamp
    var notificationDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
