/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Back button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
                            }
                            .padding(.vertical, 8)
                            .background(Color("MainColor").opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)

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
