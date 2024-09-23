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

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(LocalizedStringKey("help_center_description"))
                            .font(.body)

                        // Add more help content or FAQs here
                        Text(LocalizedStringKey("faq1"))
                            .font(.headline)
                        Text(LocalizedStringKey("faq1_answer"))
                            .font(.body)

                        Text(LocalizedStringKey("faq2"))
                            .font(.headline)
                        Text(LocalizedStringKey("faq2_answer"))
                            .font(.body)

                    }
                    .padding()
                }

                Spacer()
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(LocalizedStringKey("help_center_title"))
            .onAppear {
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss() 
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
