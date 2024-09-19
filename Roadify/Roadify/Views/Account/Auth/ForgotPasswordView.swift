//
//  ForgotPasswordView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var emailSent: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.title2)
                .bold()
            
            // Email Input Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.headline)
                
                TextField("Enter your email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
                    .foregroundColor(.white)
            }
            
            // Send Reset Email Button
            Button(action: {
                sendPasswordResetEmail()
            }) {
                HStack {
                    Spacer()
                    Text("Confirm Your Email")
                        .foregroundColor(Color.black)
                        .bold()
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            }
            
            // Show loading spinner if email is being sent
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                    .scaleEffect(1.5)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                // Go back to the SignInView after pressing OK
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    // Function to send password reset email
    func sendPasswordResetEmail() {
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                } else {
                    alertMessage = "A confirmation link has been sent to your email."
                }
                showAlert = true
            }
        }
    }
}
