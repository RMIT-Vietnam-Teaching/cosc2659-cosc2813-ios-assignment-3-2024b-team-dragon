import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()

            // Username Field
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(.black)

            // First Name and Last Name
            HStack {
                TextField("First Name", text: $viewModel.firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                TextField("Last Name", text: $viewModel.lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .foregroundColor(.black)

            // Email Field
            TextField("Email Address", text: $viewModel.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .foregroundColor(.black)

            // Password Field
            SecureField("Create Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(.black)

            // Error message display
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            // Continue Button (Sends email verification after sign-up)
            Button(action: {
                viewModel.signUpWithEmailPassword()
            }) {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }

            Spacer()

            // OTP Verification Section (Check if email is verified)
            if viewModel.isRegistered {
                VStack {
                    Text("OTP Verification")
                        .font(.headline)
                        .padding(.top)

                    Button(action: {
                        viewModel.checkEmailVerification()
                    }) {
                        Text("Check Email Verification")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }

                    if viewModel.isOTPVerified {
                        Text("Email Verified")
                            .foregroundColor(.green)
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
