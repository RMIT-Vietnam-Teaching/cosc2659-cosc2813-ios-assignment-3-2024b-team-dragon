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
    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
}
