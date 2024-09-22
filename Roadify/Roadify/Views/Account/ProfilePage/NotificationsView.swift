import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.notifications) { notification in
                VStack(alignment: .leading) {
                    Text(notification.title)
                        .font(.headline)
                    Text(notification.body)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(notification.timestamp, formatter: notificationDateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Notifications")
        }
    }
    
    // Formatter for displaying timestamp
    var notificationDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
