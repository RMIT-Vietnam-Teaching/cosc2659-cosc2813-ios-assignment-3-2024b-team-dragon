//
//  PrivacyPolicyView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import Foundation
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("""
    Your privacy is important to us. This privacy policy explains how we collect, use, disclose, and safeguard your information when you use our application.
    
    1. **Information Collection**: We may collect information about you when you use our app, including personal data like your name, email, and profile image.
    
    2. **Usage Data**: We collect usage data to improve our services and provide better user experience.
    
    3. **Data Sharing**: We do not share your personal information with third parties without your consent, except as required by law.
    
    4. **Security**: We implement security measures to protect your data from unauthorized access and use.
    
    5. **Changes**: We may update this privacy policy from time to time. Any changes will be posted in this section.
    
    If you have any questions about this privacy policy, please contact us at roadify911@gmail.com.
    """)
                    .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                NavigationBarAppearance.setupNavigationBar()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }


