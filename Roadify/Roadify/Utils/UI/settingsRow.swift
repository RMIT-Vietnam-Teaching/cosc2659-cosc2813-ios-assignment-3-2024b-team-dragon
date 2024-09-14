import Foundation
import SwiftUI

func settingsRow(iconName: String, label: String) -> some View {
    HStack {
        Image(systemName: iconName)
            .foregroundColor(.green)
        Text(label)
        Spacer()
        Image(systemName: "chevron.right")
    }
    .padding()
    .background(Color(red: 96/255, green: 100/255, blue: 105/255).edgesIgnoringSafeArea(.all).opacity(0.5))
    .cornerRadius(8)
}
