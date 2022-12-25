import SwiftUI
import SoundManager

struct SettingsView: View {
    @AppStorage("keyForAPI") var apiKey: String = ""
    @AppStorage("sounds") var sounds: Bool = true
    @Binding var showWindow: Bool
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    showWindow = false
                }
                .buttonStyle(.borderless)
                Text("Settings")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
            }
            Section {
                HStack {
                    Toggle("Sounds", isOn: $sounds)
                        .toggleStyle(.checkbox)
                        .padding(.vertical, 15)
                        .onChange(of: sounds, perform: {value in
                            Sounds.muteSound(!value)
                            Sounds.playSound("question")
                        })
                    Spacer()
                    Text("Play sounds to improve your experience")
                        .font(.subheadline)
                        .padding(.vertical, 15)
                }
            }
            
            Section() {
                HStack {
                    Text("Current API key:")
                        .padding(.vertical, 15)
                    Text("\(apiKey)")
                        .padding(.vertical, 10)
                }
                HStack {
                    Button("Reset API key") {
                        apiKey = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 15)
                    Spacer()
                    Text("Delete the API key value")
                        .font(.subheadline)
                        .padding(.vertical, 15)
                }
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var closeValue: Bool = false
    static var previews: some View {
        SettingsView(showWindow: $closeValue)
    }
}
