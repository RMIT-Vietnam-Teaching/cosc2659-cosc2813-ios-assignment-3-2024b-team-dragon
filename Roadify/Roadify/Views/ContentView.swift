import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
        }
        .padding()
    }
}

struct ContentView_Providerr: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
