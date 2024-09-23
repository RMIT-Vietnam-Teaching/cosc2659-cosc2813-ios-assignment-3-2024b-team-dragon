/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import SwiftUI

struct AdminPanelView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPendingPinView = false
    @State private var showPinManagementView = false
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Button(action: {
                    showPendingPinView = true
                }) {
                    SettingsRow(iconName: "gift.fill", label: NSLocalizedString("PendingPins", comment: "Pending Pins"))
                }
                .sheet(isPresented: $showPendingPinView) {
                    PendingPinView()
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }
                
                Button(action: {
                    showPinManagementView = true
                }) {
                    SettingsRow(iconName: "shield.fill", label: NSLocalizedString("PinManagement", comment: "Pin Management"))
                }
                .sheet(isPresented: $showPinManagementView) {
                    PinManagementView()
                        .preferredColorScheme(darkModeEnabled ? .dark : .light)
                }
                
                Spacer()
            }
            .padding()
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(NSLocalizedString("Admin_nav", comment: "Admin Panel"))
            .onAppear {
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss() 
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct AdminPanelView_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanelView()
    }
}
