/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date:
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import AVFoundation
import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authManager = AuthManager()
	
    @State private var navigateToNextView = false
	@State private var audioPlayer: AVAudioPlayer?

    @Binding var selectedPin: Pin?
    @Binding var selectedTab: Int
    @Binding var isFromMapView: Bool

    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea(.all)

            VStack {
                // Display the GIF
                GIFImage(gifName: "GIF1")
                    .frame(width: 350, height: 350)
            }
        }
        .onAppear {
            playSound()
            // Simulate a delay for the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                audioPlayer?.stop() 
                withAnimation {
                    navigateToNextView = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToNextView) {
            if authManager.isLoggedIn {
                TabView(
                    selectedPin: $selectedPin, selectedTab: $selectedTab,
                    isFromMapView: $isFromMapView)
            } else {
                WelcomeView(
                    selectedPin: $selectedPin, selectedTab: $selectedTab,
                    isFromMapView: $isFromMapView)
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
    @State static var selectedPin: Pin?
    @State static var selectedTab: Int = 0
    @State static var isFromMapView: Bool = false

    static var previews: some View {
        SplashScreenView(
            selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
    }
}
