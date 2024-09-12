import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel = SignInViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            TextField("Email", text: $viewModel.loginCredentials.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $viewModel.loginCredentials.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                viewModel.login()
            }) {
                Text("Sign In")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }
            .padding(.top, 20)

            if viewModel.isLoggedIn {
                Text("Login Successful!")
                    .foregroundColor(.green)
                    .font(.headline)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
