/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 19/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import Foundation
import SwiftUI

struct AccountNotLoginView: View {
    @State private var navigateToLogin: Bool = false
    @State private var navigateToRegister: Bool = false
    
    @Binding var selectedPin: Pin?
    @Binding var selectedTab: Int
    @Binding var isFromMapView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("You're not logged in")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                VStack {
                    Text("Sign in to help the ")
                        .foregroundColor(.white)
                    + Text("community")
                        .foregroundColor(Color("SubColor"))
                    + Text(" and ")
                        .foregroundColor(.white)
                    
                    Text("connect")
                        .foregroundColor(Color("SubColor"))
                    + Text(" with other drivers")
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                
                Spacer()
                
                Image("NotLogin")
                    .resizable()
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
                .padding([.horizontal, .bottom], 30)
                
                // "New to Roadify?"
                HStack {
                    Text("Already had a")
                        .foregroundColor(.white)
                    + Text(" Roadify")
                        .foregroundColor(Color("SubColor"))
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
                        .background(Color("MainColor"))
                        .foregroundColor(Color("SubColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                    .navigationDestination(
                        isPresented: $navigateToRegister
                    ) {
                        SignUpView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
                    }
                
                    .navigationDestination(
                        isPresented: $navigateToLogin
                    ) {
                        SignInView(selectedPin: $selectedPin, selectedTab: $selectedTab, isFromMapView: $isFromMapView)
                    }
            }
            .padding()
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
    }
}
