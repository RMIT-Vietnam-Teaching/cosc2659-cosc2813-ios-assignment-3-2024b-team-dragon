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
    .background(Color("ThirdColor").edgesIgnoringSafeArea(.all).opacity(0.5))
    .cornerRadius(8)
}
