/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement:
 */

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
                    SettingsRow(
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
                            .foregroundColor(.green)
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
                    SettingsRow(
                        iconName: "clock",
                        label: NSLocalizedString("Privacy_Logs", comment: "ActivityLogs"))
                }
                .sheet(isPresented: $showActivityLogs) {
                    ActivityLogsView()
                }

                Button(action: {
                    showPrivacyPolicy = true
                }) {
                    SettingsRow(
                        iconName: "doc.text.magnifyingglass",
                        label: NSLocalizedString("Privacy_Policy", comment: "Privacy Policy"))
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    PrivacyPolicyView()
                }

                Button(action: {
                    showTermsOfService = true
                }) {
                    SettingsRow(
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
