import SwiftUI
import UIKit

enum Field {
    case username, firstName, lastName, email, password
}

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
    @FocusState private var focusedField: Field?
    @State private var activeField: Field? = nil
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    @State private var isLoading: Bool = false // State for loading indicator
    @State private var showOTPSection: Bool = false // State for showing OTP section after delay
    @State private var navigateToSignIn: Bool = false // State for navigation
    @State private var showContinueButton: Bool = true // State for showing/hiding Continue button
    

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)

                // Username Field
                customTextField("Username", text: $viewModel.username, field: .username, isValid: $viewModel.isUsernameValid, iconName: "person")

                // First Name and Last Name with spacing
                HStack(spacing: 15) {
                    customTextField("First Name", text: $viewModel.firstName, field: .firstName, isValid: $viewModel.isFirstNameValid, iconName: "person.fill")
                    customTextField("Last Name", text: $viewModel.lastName, field: .lastName, isValid: $viewModel.isLastNameValid, iconName: "person.fill")
                }

                // Email Field
                customTextField("Email Address", text: $viewModel.email, field: .email, isValid: $viewModel.isEmailValid, iconName: "envelope")
                    .autocapitalization(.none) // Disable autocapitalization


                // Password Field with eye icon toggle
                passwordTextField("Create Password", text: $viewModel.password, field: .password, isValid: $viewModel.isPasswordValid, iconName: "lock", isPasswordVisible: $isPasswordVisible, textContentType: .oneTimeCode)

                // Repeat Password Field with eye icon toggle
                passwordTextField("Repeat Password", text: $viewModel.repeatPassword, field: .password, isValid: $viewModel.isRepeatPasswordValid, iconName: "lock.fill", isPasswordVisible: $isRepeatPasswordVisible, textContentType: .oneTimeCode)

                // Error message display
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                // Continue Button
                if showContinueButton {
                    Button(action: {
                        // Start loading and show OTP section after a delay
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // 5 seconds delay
                            isLoading = false
                            showOTPSection = true
                            showContinueButton = false // Hide Continue button
                        }
                        viewModel.signUpWithEmailPassword()
                    }) {
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(Color("ThirdColor"))
                    }
                }
                
                Spacer()
                
                // Show loading indicator while loading
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                            .scaleEffect(1.5)
                            .padding()
                    }
                    .background(Color.black.opacity(0).edgesIgnoringSafeArea(.all))
                }

                // OTP Verification Section
                if showOTPSection {
                    VStack {
                        Button(action: {
                            viewModel.checkEmailVerification()
                        }) {
                            Text("Check Email Verification")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("SecondaryColor"))
                                .foregroundColor(Color("FourthColor"))
                                .cornerRadius(8)
                        }

                        if viewModel.isOTPVerified {
                            Text("Email Verified")
                                .foregroundColor(Color("SecondaryColor"))
                                .font(.headline)
                                .onAppear {
                                    // Delay before navigating to SignInView
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        navigateToSignIn = true
                                    }
                                }
                        }
                    }
                }

                NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) {
                    EmptyView()
                }
            }
            .padding()
            .background(Color("PrimaryColor").edgesIgnoringSafeArea(.all))
        }
    }
    
    private func customTextField(_ placeholder: String, text: Binding<String>, field: Field, isValid: Binding<Bool?>, iconName: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.caption)
                .foregroundColor(Color.white)
            
            ZStack(alignment: .leading) {
                // Background color and border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid.wrappedValue == nil ? Color("ThirdColor") : (isValid.wrappedValue! ? .green : .red), lineWidth: 2)
                    .background(Color("PrimaryColor"))
                
                // Icon inside the TextField
                Image(systemName: iconName)
                    .foregroundColor(self.activeField == field ? .white : Color.white)
                    .padding(.leading, 10)
                
                HStack {
                    // Actual TextField
                    TextField(placeholder, text: text)
                        .padding(.leading, 30) // Add padding to avoid overlapping with icon
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(self.activeField == field ? .white : Color("ThirdColor"))
                        .focused($focusedField, equals: field)
                        .onChange(of: focusedField) { newValue in
                            if newValue == nil {
                                self.activeField = field
                            }
                        }
                        .onTapGesture {
                            self.activeField = field
                        }
                    
                    Spacer()
                    
                    // Validation icon
                    if let isValidValue = isValid.wrappedValue {
                        Image(systemName: isValidValue ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isValidValue ? .green : .red)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 50)
        }
    }

    private func passwordTextField(_ placeholder: String, text: Binding<String>, field: Field, isValid: Binding<Bool?>, iconName: String, isPasswordVisible: Binding<Bool>, textContentType: UITextContentType? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.caption)
                .foregroundColor(Color.white)
            
            ZStack(alignment: .leading) {
                // Background color and border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid.wrappedValue == nil ? Color("ThirdColor") : (isValid.wrappedValue! ? .green : .red), lineWidth: 2)
                    .background(Color("PrimaryColor")) // Explicitly set the background color
                
                // Icon inside the TextField
                Image(systemName: iconName)
                    .foregroundColor(self.activeField == field ? .white : Color.white)
                    .padding(.leading, 10)
                
                HStack {
                    // Actual TextField or SecureField
                    Group {
                        if isPasswordVisible.wrappedValue {
                            TextField(placeholder, text: text)
                                .textContentType(textContentType) // Set text content type

                        } else {
                            SecureField(placeholder, text: text)
                                .textContentType(textContentType) // Set text content type

                        }
                    }
                    .padding(.leading, 30) // Padding to avoid overlapping with icon
                    .padding()
                    .background(Color.clear)
                    .foregroundColor(self.activeField == field ? .white : Color("ThirdColor"))
                    .focused($focusedField, equals: field)
                    .onChange(of: focusedField) { newValue in
                        if newValue == nil {
                            self.activeField = field
                        }
                    }
                    .onTapGesture {
                        self.activeField = field
                    }
                    
                    Spacer()
                    
                    // Eye icon for password visibility toggle
                    Button(action: {
                        isPasswordVisible.wrappedValue.toggle()
                    }) {
                        Image(systemName: isPasswordVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(self.activeField == field ? .white : Color.white)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 50)
        }
    }
}
