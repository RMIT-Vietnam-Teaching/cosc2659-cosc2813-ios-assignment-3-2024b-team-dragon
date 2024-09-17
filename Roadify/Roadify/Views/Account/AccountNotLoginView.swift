import SwiftUI

struct AccountNotLoginView: View {
    @State private var navigateToLogin: Bool = false
    @State private var navigateToRegister: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title or message to indicate the user is not logged in
                Text("You're not logged in")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Subtitle or additional information with styled words, broken into multiple Text views
                VStack {
                    Text("Sign in to help the ")
                        .foregroundColor(.white)
                    + Text("community")
                        .foregroundColor(Color("SecondaryColor"))
                    + Text(" and ")
                        .foregroundColor(.white)
                    
                    Text("connect")
                        .foregroundColor(Color("SecondaryColor"))
                    + Text(" with other drivers")
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

                Spacer()

                // Add the GIF
                GIFImage(gifName: "GIF2") // Use the name 'gif' without the .gif extension
                    .frame(width: 300, height: 300)

                // Register Button
                Button(action: {
                    navigateToRegister = true
                }) {
                    Text("Create an Account")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)

                // "New to Roadify?"
                HStack {
                    Text("Already had a")
                        .foregroundColor(.white)
                    + Text(" Roadify")
                        .foregroundColor(Color("SecondaryColor"))
                    + Text(" account?")
                        .foregroundColor(.white)
                }
                .font(.headline)
                .padding(.bottom, 5)

                // Sign In Button
                Button(action: {
                    navigateToLogin = true
                }) {
                    Text("Sign In")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryColor")) // Background set to PrimaryColor
                        .foregroundColor(Color("SecondaryColor")) // Text set to SecondaryColor
                        .cornerRadius(10)
                        .overlay( // Adding a grey border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 30)

                Spacer()

                // Navigation Links
                NavigationLink(destination: SignUpView(), isActive: $navigateToRegister) {
                    EmptyView()
                }

                NavigationLink(destination: SignInView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
            }
            .padding()
            .background(Color("PrimaryColor").edgesIgnoringSafeArea(.all))
        }
    }
}
