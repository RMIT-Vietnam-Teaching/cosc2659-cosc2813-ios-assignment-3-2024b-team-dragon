import SwiftUI
import AVFoundation

struct SplashScreenView: View {
    @StateObject private var authManager = AuthManager()
    @State private var navigateToNextView = false
    @State private var selectedTab: Int = 0
    @State private var audioPlayer: AVAudioPlayer?

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
            playSound()
            // Simulate a delay for the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                audioPlayer?.stop() // Stop the sound
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
    
    private func playSound() {
        // Load sound from the Assets catalog
        guard let asset = NSDataAsset(name: "sound") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(data: asset.data)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
