import SwiftUI

struct ActivityLogsView: View {
    @StateObject private var viewModel = ActivityLogsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Activity Logs")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.activityLogs.isEmpty {
                    Text("No activity logs available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.activityLogs) { log in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(log.action)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Text("\(log.timestamp, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(Color("SubColor"))
                        }
                        .padding(.vertical, 5)
                        .background(Color("MainColor"))
                        .cornerRadius(8)
                        .listRowBackground(Color("MainColor")) // Set the background color for list rows
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("MainColor"))
                }
                
                Spacer()
            }
            .background(Color("MainColor").edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationBarHidden(true)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct ActivityLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLogsView()
    }
}
