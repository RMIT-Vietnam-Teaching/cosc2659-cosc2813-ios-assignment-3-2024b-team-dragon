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

import Foundation
import SwiftUI

func SettingsRow(iconName: String, label: String) -> some View {
    HStack {
        Image(systemName: iconName)
            .foregroundColor(.green)
        Text(label)
        Spacer()
        Image(systemName: "chevron.right")
    }
    .padding()
    .background(Color("ThirdColor").edgesIgnoringSafeArea(.all).opacity(0.5))
    .cornerRadius(8)
}
