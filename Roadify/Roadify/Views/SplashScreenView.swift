import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var navigateToWelcomeView = false
    
    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea(.all) // Background color of the splash screen
            
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
                    navigateToWelcomeView = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToWelcomeView, content: {
            // Replace `NextView` with the view you want to navigate to
            WelcomeView()
        })
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
