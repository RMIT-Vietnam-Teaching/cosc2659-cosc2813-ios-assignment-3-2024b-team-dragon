//
//  AdminPanelView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI

struct AdminPanelView: View {
    @State private var showPendingPinView = false
    @State private var showPinManagementView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Admin Panel")
                .font(.title2)
                .bold()
            
            Button(action: {
                showPendingPinView = true
            }) {
                settingsRow(iconName: "gift.fill", label: "Pending Pins")
            }
            .sheet(isPresented: $showPendingPinView) {
                PendingPinView() // Replace with your actual view for pending pins
            }
            
            Button(action: {
                showPinManagementView = true
            }) {
                settingsRow(iconName: "shield.fill", label: "Pin Management")
            }
            .sheet(isPresented: $showPinManagementView) {
                PinManagementView() // Replace with your actual view for user management
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
                .foregroundColor(Color("SubColor")) // Adjust the color to match the icons
            Text(label)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
    }
}

struct AdminPanelView_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanelView()
    }
}
