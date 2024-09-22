/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 20/9/24
 Last modified: 22/9/24
 Acknowledgement:
 */

//
//  LanguageSelectionView.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 20/9/24.
//

import Foundation
import SwiftUI

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    @Binding var selectedLanguageFlag: String
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button(action: {
                    selectedLanguage = "English"
                    selectedLanguageFlag = "us"
                    changeLanguage(to: "en")
                }) {
                    languageRow(language: "English", flag: "us")
                }
                
                Button(action: {
                    selectedLanguage = "Vietnamese"
                    selectedLanguageFlag = "vn"
                    changeLanguage(to: "vi")
                }) {
                    languageRow(language: "Vietnamese", flag: "vn")
                }
                
                Spacer()
            }
            .padding()
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(LocalizedStringKey("select_language"))
            .onAppear(){
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss() // Dismiss the view when "X" is tapped
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(LocalizedStringKey("language_change_title")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(LocalizedStringKey("ok")))
                )
            }
        }
    }
    
    private func languageRow(language: String, flag: String) -> some View {
        HStack {
            Image(flag)
                .resizable()
                .frame(width: 24, height: 24)
            Text(language)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThirdColor").opacity(0.5)))
    }
    
    // Function to change the language and show alert
    func changeLanguage(to language: String) {
        appLanguage = language
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Show alert with a restart message
        alertMessage = NSLocalizedString("please_restart", comment: "Please restart the app to apply the changes.")
        showAlert = true
    }
}
