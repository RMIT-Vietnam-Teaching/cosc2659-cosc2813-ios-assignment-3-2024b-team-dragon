
import Foundation
import SwiftUI

struct TabView: View {
    @StateObject private var authManager = AuthManager()
	@State private var selectedTab = 0
	@State private var showWelcomeView = true // First launch
	
	var body: some View {
		VStack (spacing: 0) {
            if authManager.isLoggedIn {
                switch selectedTab {
                case 0:
                    MapView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 1:
                    NewsView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 2:
                    MapView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 3:
                    AccountView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                default:
                    Text("Invalid tab")
                }
            } else {
                switch selectedTab {
                case 0:
                    MapView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 1:
                    NewsView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 2:
                    MapView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                case 3:
                    AccountNotLoginView()
                        .onAppear {
                            authManager.refreshAuthStatus()
                        }
                default:
                    Text("Invalid tab")
                }
            }
		
			HStack {
				// MapsView
				TabButtonView(viewIsSelected: "map_on", viewIsNotSelected: "map_off", isSelected: selectedTab == 0) {
					selectedTab = 0
				}
				
				// NewsView
				TabButtonView(viewIsSelected: "news_on", viewIsNotSelected: "news_off", isSelected: selectedTab == 1) {
					selectedTab = 1
				}
				
				// AlertView
				TabButtonView(viewIsSelected: "alert_on", viewIsNotSelected: "alert_off", isSelected: selectedTab == 2) {
					selectedTab = 2
				}
				
				// ProfileView
				TabButtonView(viewIsSelected: "user_on", viewIsNotSelected: "user_off", isSelected: selectedTab == 3) {
                    selectedTab = 3
				}
			}
			.padding()
			.background(Color("Primary"))
		}
		.edgesIgnoringSafeArea(.bottom)
			}
		}
		.onAppear {
			checkFirstLaunch()
		}
	}
	
	func checkFirstLaunch() {
		let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
		if hasLaunchedBefore {
			showWelcomeView = false
		} else {
			UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
			showWelcomeView = true
		}
	}
}

struct TabView_Previews: PreviewProvider {
	static var previews: some View {
		TabView()
	}
}
