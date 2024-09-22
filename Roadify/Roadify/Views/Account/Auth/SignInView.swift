//
//  SignInView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 19/9/24.
//

import SwiftUI

enum SignInField: Hashable {
    case email
    case password
}

struct SignInView: View {
    @ObservedObject var viewModel = SignInViewModel()

    @FocusState private var focusedField: SignInField?
    @State private var activeField: SignInField? = nil
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        //        NavigationView { *FixYellowWarning*no
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)

                // Email Field
                customTextField(
                    "Email Address", text: $viewModel.loginCredentials.email, field: .email,
                    iconName: "envelope"
                )
                .autocapitalization(.none)  // Disable autocapitalization

                // Password Field with eye icon toggle
                passwordTextField(
                    "Password", text: $viewModel.loginCredentials.password, field: .password,
                    iconName: "lock", isPasswordVisible: $isPasswordVisible)

                // Forgot Password Button
                forgotPasswordButton()

                // Error message display
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                // Login Button
                Button(action: {
                    // Start loading indicator while logging in
                    isLoading = true
                    viewModel.login()

                    // Simulate network delay to stop loading indicator
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }) {
                    Text("Sign In")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(Color.black)
                }

                // Navigate if logged in successfully
                //                NavigationLink(destination: TabView(), isActive: $viewModel.isLoggedIn) {
                //                    EmptyView()
                //                } *FixYellowWarning*
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    AccountView()  // Double-check
                    EmptyView()
                }

                Spacer()

                // Show loading indicator while loading
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(1.5)
                        .padding()
                }
            }
            .padding()
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        }
    }

    // Custom text field for email and password
    private func customTextField(
        _ placeholder: String, text: Binding<String>, field: SignInField, iconName: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.caption)
                .foregroundColor(Color.white)

            ZStack(alignment: .leading) {
                // Background color and border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("ThirdColor"), lineWidth: 2)
                    .background(Color("MainColor"))

                // Icon inside the TextField
                Image(systemName: iconName)
                    .foregroundColor(self.activeField == field ? .white : Color.white)
                    .padding(.leading, 10)

                HStack {
                    // Actual TextField
                    TextField(placeholder, text: text)
                        .padding(.leading, 30)  // Add padding to avoid overlapping with icon
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(self.activeField == field ? .white : Color("ThirdColor"))
                        .focused($focusedField, equals: field)
                        .onTapGesture {
                            self.activeField = field
                        }

                    Spacer()
                }
            }
            .frame(height: 50)
        }
    }

    // Custom password field with toggle for visibility
    private func passwordTextField(
        _ placeholder: String, text: Binding<String>, field: SignInField, iconName: String,
        isPasswordVisible: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.caption)
                .foregroundColor(Color.white)

            ZStack(alignment: .leading) {
                // Background color and border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("ThirdColor"), lineWidth: 2)
                    .background(Color("MainColor"))

                // Icon inside the TextField
                Image(systemName: iconName)
                    .foregroundColor(self.activeField == field ? .white : Color.white)
                    .padding(.leading, 10)

                HStack {
                    // Actual TextField
                    Group {
                        if isPasswordVisible.wrappedValue {
                            TextField(placeholder, text: text)
                        } else {
                            SecureField(placeholder, text: text)
                        }
                    }
                    .padding(.leading, 30)  // Padding to avoid overlapping with icon
                    .padding()
                    .background(Color.clear)
                    .foregroundColor(self.activeField == field ? .white : Color("ThirdColor"))
                    .focused($focusedField, equals: field)
                    .onTapGesture {
                        self.activeField = field
                    }

                    Spacer()

                    // Eye icon for showing/hiding password
                    Button(action: {
                        isPasswordVisible.wrappedValue.toggle()
                    }) {
                        Image(
                            systemName: isPasswordVisible.wrappedValue
                                ? "eye.fill" : "eye.slash.fill"
                        )
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 50)
        }
    }

    // Forgot password button
    private func forgotPasswordButton() -> some View {
        HStack {
            Spacer()

            // Forgot Password Text and Icon
            NavigationLink(destination: ForgotPasswordView()) {
                HStack(spacing: 5) {
                    Image(systemName: "key.fill")
                        .foregroundColor(Color("SubColor"))

                    Text("Forgot Password?")
                        .foregroundColor(.white)
                        .font(.caption)
                        .underline()
                }
            }
        }
        .padding(.trailing, 10)
    }
}
