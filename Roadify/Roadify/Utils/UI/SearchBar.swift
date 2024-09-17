import SwiftUI

import SwiftUI

struct SearchBar: View {
    var label: String
    @Binding var text: String  // Bind search text from the parent view

    var body: some View {
        HStack {
            TextField(label, text: $text)  // Bind to the provided text
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(label: "Search...", text: .constant(""))
    }
}

