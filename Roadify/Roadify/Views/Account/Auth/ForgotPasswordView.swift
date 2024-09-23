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
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var emailSent: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("forgotPassword_emailLabel", comment: "Label for email field"))
                        .font(.headline)
                    
                    TextField(NSLocalizedString("forgotPassword_placeholderEmail", comment: "Placeholder for email input"), text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Send Reset Email Button
                Button(action: {
                    sendPasswordResetEmail()
                }) {
                    HStack {
                        Spacer()
                        Text(NSLocalizedString("forgotPassword_confirmButton", comment: "Button title to confirm email"))
                            .foregroundColor(Color.black)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                .padding(.horizontal, 20)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                        .scaleEffect(1.5)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(NSLocalizedString("forgotPassword_navigationTitle", comment: "Navigation title for forgot password"))
            .onAppear(){
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text(NSLocalizedString("forgotPassword_alertTitle", comment: "Alert title")), message: Text(alertMessage), dismissButton: .default(Text(NSLocalizedString("forgotPassword_alertButtonOK", comment: "Alert button OK")), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }
    }
    
    // Function to send password reset email
    func sendPasswordResetEmail() {
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
                if let error = error {
                    alertMessage = NSLocalizedString("forgotPassword_errorMessage", comment: "Error message") + "\(error.localizedDescription)"
                } else {
                    alertMessage = NSLocalizedString("forgotPassword_emailSentMessage", comment: "Confirmation email sent message")
                }
                showAlert = true
            }
        }
    }
}
