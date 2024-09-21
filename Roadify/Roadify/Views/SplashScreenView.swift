import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authManager = AuthManager()
    @State private var navigateToNextView = false
	
	@Binding var selectedPin: Pin?
	@Binding var selectedTab: Int
	@Binding var isFromMapView: Bool
	@Binding var isDetailPinViewPresented: Bool

    
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
				TabView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView, isDetailPinViewPresented: $isDetailPinViewPresented)
            } else {
				WelcomeView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView, isDetailPinViewPresented: $isDetailPinViewPresented)
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
	@State static var selectedPin: Pin?
	@State static var selectedTab: Int = 0
	@State static var isFromMapView: Bool = false
	@State static var isDetailPinViewPresented: Bool = false

    static var previews: some View {
		SplashScreenView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView, isDetailPinViewPresented: $isDetailPinViewPresented)
    }
}
