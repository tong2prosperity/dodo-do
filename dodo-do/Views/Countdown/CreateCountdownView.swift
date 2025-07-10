import SwiftUI

struct CreateCountdownView: View {
    @ObservedObject var viewModel: CountdownListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 25
    @State private var seconds: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("New Countdown")
                .font(.title2)
                .fontWeight(.semibold)

            // Title Field
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Custom Time Picker Wheels
            HStack(spacing: 10) {
                WheelPickerView(selection: $hours, range: 0..<24, label: "h")
                Text("h").font(.headline)
                WheelPickerView(selection: $minutes, range: 0..<60, label: "m")
                Text("m").font(.headline)
                WheelPickerView(selection: $seconds, range: 0..<60, label: "s")
                Text("s").font(.headline)
            }
            .padding(.horizontal)

            // Action Buttons
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Create") {
                    let durationInSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
                    if durationInSeconds > 0 && !title.isEmpty {
                        viewModel.createCountdown(title: title, duration: durationInSeconds)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.isEmpty || (hours == 0 && minutes == 0 && seconds == 0))
            }
            .padding()
        }
        .frame(width: 320, height: 300)
        .padding()
    }
}
