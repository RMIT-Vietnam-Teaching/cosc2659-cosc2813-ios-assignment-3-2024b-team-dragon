import Foundation
import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    Text(
                        NSLocalizedString(
                            "terms_of_service_text", comment: "Terms of Service Description")
                    )
                    .padding(.horizontal)

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationTitle(
                NSLocalizedString("terms_of_service_title", comment: "Terms of Service Title")
            )
            .onAppear {
                NavigationBarAppearance.setupNavigationBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()  // Dismiss the sheet when the "X" is tapped
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

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
    }
}
