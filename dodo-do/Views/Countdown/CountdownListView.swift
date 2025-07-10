import SwiftUI

struct CountdownListView: View {
    @StateObject private var viewModel = CountdownListViewModel()
    @State private var showingCreateSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text("Countdowns")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                
                if !viewModel.countdowns.isEmpty {
                    Button("Clear All") {
                        viewModel.clearAllCountdowns()
                    }
                    .foregroundColor(.red)
                }

                Button(action: { showingCreateSheet = true }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(.primary)
            }

            // List
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.countdowns) { countdown in
                        CountdownItemView(viewModel: viewModel, countdown: countdown)
                        Divider()
                    }
                }
            }
        }
        .padding()
        .frame(width: 450, height: 600)
        .sheet(isPresented: $showingCreateSheet) {
            CreateCountdownView(viewModel: viewModel)
        }
    }
}

struct CountdownItemView: View {
    @ObservedObject var viewModel: CountdownListViewModel
    let countdown: CountdownItem

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(countdown.title)
                    .font(.headline)
                Text(viewModel.format(duration: countdown.remainingDuration))
                    .font(.subheadline)
                    .foregroundColor(countdown.isRunning ? .green : .secondary)
            }
            
            Spacer()
            
            // Controls
            Button(action: { viewModel.togglePlayPause(for: countdown) }) {
                Image(systemName: countdown.isRunning ? "pause.fill" : "play.fill")
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: { viewModel.resetCountdown(for: countdown) }) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

struct CountdownListView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownListView()
    }
}
