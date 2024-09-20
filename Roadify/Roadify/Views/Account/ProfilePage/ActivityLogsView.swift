//
//  ActivityLogsView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct ActivityLogsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ActivityLogsViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if viewModel.isLoading {
                    ProgressView(NSLocalizedString("activityLogs_loading", comment: "Loading..."))
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(NSLocalizedString("activityLogs_error", comment: "Error message") + ": \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.activityLogs.isEmpty {
                    Text(NSLocalizedString("activityLogs_noLogs", comment: "No activity logs available"))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.activityLogs) { log in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(log.action)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Text("\(log.timestamp, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(Color("SubColor"))
                        }
                        .padding(.vertical, 5)
                        .background(Color("MainColor"))
                        .cornerRadius(8)
                        .listRowBackground(Color("MainColor")) // Set the background color for list rows
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("MainColor"))
                }
                
                Spacer()
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(NSLocalizedString("activityLogs_title", comment: "Activity Logs"))
            .onAppear(){
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Dismiss the sheet when the "X" is tapped
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
