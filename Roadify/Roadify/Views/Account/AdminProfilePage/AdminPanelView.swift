//
//  AdminPanelView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI

struct AdminPanelView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPendingPinView = false
    @State private var showPinManagementView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Button(action: {
                    showPendingPinView = true
                }) {
                    SettingsRow(iconName: "gift.fill", label: NSLocalizedString("PendingPins", comment: "Pending Pins"))
                }
                .sheet(isPresented: $showPendingPinView) {
                    PendingPinView() // Replace with your actual view for pending pins
                }
                
                Button(action: {
                    showPinManagementView = true
                }) {
                    SettingsRow(iconName: "shield.fill", label: NSLocalizedString("PinManagement", comment: "Pin Management"))
                }
                .sheet(isPresented: $showPinManagementView) {
                    PinManagementView() // Replace with your actual view for pin management
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
                        dismiss()  // Dismiss the sheet when the "X" is tapped
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
