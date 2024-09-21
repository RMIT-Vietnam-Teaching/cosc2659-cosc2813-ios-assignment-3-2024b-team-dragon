import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authManager = AuthManager()
    @State private var navigateToNextView = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea(.all) // Background color of the splash screen
            
            VStack {
                // Display the GIF
                GIFImage(gifName: "GIF1") // Use the name without .gif extension
                    .frame(width: 350, height: 350)
            }
        }
        .onAppear {
            // Simulate a delay for the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    navigateToNextView = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToNextView) {
            if authManager.isLoggedIn {
                TabView(selectedTab: $selectedTab)
            } else {
                WelcomeView()
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
