import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @State private var navigateToTabView = false  // New state variable

    @Binding var selectedPin: Pin?
    @Binding var selectedTab: Int
    @Binding var isFromMapView: Bool

    let totalPage = 3
    @State private var selectedTab: Int = 0

    var body: some View {
        //        NavigationView { *FixYellowWarning*
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    if currentPage < totalPage - 1 {
                        Button(action: {
                            currentPage = totalPage - 1
                        }) {
                            Text("Skip")
                                .foregroundColor(Color("SubColor"))
                                .bold()
                                .padding(.trailing, 35)
                        }
                    }
                }
                .padding(.top, 90)

                Spacer()

                PageViewModel(
                    image: currentPageImage,
                    title: currentPageTitle,
                    description: currentPageDescription,
                    onNext: nextPage,
                    progress: pageProgress,
                    progressColor: ""
                )

                HStack(spacing: 10) {
                    ForEach(0..<totalPage, id: \.self) { index in
                        Button(action: {
                            // show current step
                            currentPage = index
                        }) {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(currentPage == index ? Color("SubColor") : .gray)
                                //                                .animation(.easeInOut) *FixYellowWarning*
                                .animation(.easeInOut, value: 1)

                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 20)

                Spacer()

                    // Navigation Link to TabView
                    //                NavigationLink(
                    //                    destination: TabView().navigationBarBackButtonHidden(true), // Replace with your TabView
                    //                    isActive: $navigateToTabView,
                    //                    label: {
                    //                        EmptyView()
                    //                    }
                    //                ) *FixYellowWarning*
                    .navigationDestination(isPresented: $navigateToTabView) {
                        TabView(
                            selectedPin: $selectedPin, selectedTab: $selectedTab,
                            isFromMapView: $isFromMapView
                        ).navigationBarBackButtonHidden(true)
                        //						EmptyView()
                    }

            }
            .background(Color("MainColor"))
            .edgesIgnoringSafeArea(.all)
        }
    }

    private var currentPageImage: String {
        switch currentPage {
        case 0: return "welcomeview_img1"
        case 1: return "welcomeview_img2"
        case 2: return "welcomeview_img3"
        default: return ""
        }
    }

    private var currentPageTitle: String {
        switch currentPage {
        case 0: return "Stay Safe"
        case 1: return "Help the Community"
        case 2: return "Be a Local Guardian"
        default: return ""
        }
    }

    private var currentPageDescription: String {
        switch currentPage {
        case 0:
            return
                "View real-time accident reports nearby and choose safer routes to avoid delays and danger"
        case 1:
            return
                "Report accidents quickly to alert others and contribute to safer roads for everyone"
        case 2: return "Join a network of vigilant drivers working together to make our roads safer"
        default: return ""
        }
    }

    private var pageProgress: CGFloat {
        return CGFloat(currentPage + 1) / CGFloat(totalPage)
    }

    private func nextPage() {
        if currentPage < totalPage - 1 {
            currentPage += 1
        } else {
            navigateToTabView = true  // Trigger navigation
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    @State static var selectedPin: Pin?
    @State static var selectedTab: Int = 0
    @State static var isFromMapView: Bool = false

    static var previews: some View {
        WelcomeView(
            selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
    }
}
