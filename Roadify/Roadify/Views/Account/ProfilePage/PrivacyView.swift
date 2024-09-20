//
//  PrivacyView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showManageAccountData = false
    @State private var showActivityLogs = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfService = false
    @State private var showForgotPasswordView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button(action: {
                    showManageAccountData = true
                }) {
                    settingsRow(
                        iconName: "doc.text",
                        label: NSLocalizedString(
                            "Privacy_ManageAccount", comment: "ManageAcccount Title"))
                }
                .sheet(isPresented: $showManageAccountData) {
                    ManageAccountDataView()
                }

                Button(action: {
                    // Action for changing password
                    showForgotPasswordView = true
                }) {
                    HStack {
                        Image(systemName: "key.fill")
                        Text(
                            NSLocalizedString("Privacy_ChangePassword", comment: "Change Password"))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                }
                .sheet(isPresented: $showForgotPasswordView) {
                    ForgotPasswordView()  // Navigate to ForgotPasswordView
                }

                Button(action: {
                    showActivityLogs = true
                }) {
                    settingsRow(
                        iconName: "clock",
                        label: NSLocalizedString("Privacy_Logs", comment: "ActivityLogs"))
                }
                .sheet(isPresented: $showActivityLogs) {
                    ActivityLogsView()
                }

                Button(action: {
                    showPrivacyPolicy = true
                }) {
                    settingsRow(
                        iconName: "doc.text.magnifyingglass",
                        label: NSLocalizedString("Privacy_Policy", comment: "Privacy Policy"))
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    PrivacyPolicyView()
                }

                Button(action: {
                    showTermsOfService = true
                }) {
                    settingsRow(
                        iconName: "doc.text",
                        label: NSLocalizedString("Privacy_Terms", comment: "Terms of Service"))
                }
                .sheet(isPresented: $showTermsOfService) {
                    TermsOfServiceView()
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(NSLocalizedString("Privacy_nav", comment: "Privacy Nav Bar"))
            .onAppear {
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()  // Dismiss the sheet when the "X" is tapped
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
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
