import SwiftUI
import SoundManager

@main
struct AimaginatorApp: App {
    @AppStorage("sounds") var sounds: Bool = true
    @State var isShowAboutDialog: Bool = false
    @State var isShowSettings: Bool = false
    var body: some Scene {
        loadSounds()
        return WindowGroup {
            MainView()
            // Settings area
                .sheet(isPresented: $isShowSettings,
                       content: {
                    SettingsView(showWindow: $isShowSettings)
                })
            // About area
                .alert(isPresented: $isShowAboutDialog, content: {
                    Alert(title: Text("About this application"),
                          message: Text("About this app infoText"),
                          dismissButton:
                            Alert.Button.default(Text("OK"), action: {
                        isShowAboutDialog = false
                    })
                    )
                })
        }
        .commands {
            CommandGroup(replacing: .sidebar) {}
            CommandGroup(replacing: .appVisibility) {}
            CommandGroup(replacing: .toolbar) {}
            CommandGroup(replacing: .help) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .textEditing) {}
            CommandGroup(replacing: .appSettings) {
                Button("Settings") {
                    isShowSettings = true
                }
                .keyboardShortcut(",")
            }
            CommandGroup(replacing: .appInfo) {
                Button("About this application") {
                    isShowAboutDialog = true
                }
            }
        }
        .windowToolbarStyle(.unifiedCompact)
    }
    
    private func loadSounds() {
        Sounds.loadSound("complete", fileName: "complete.aiff")
        Sounds.loadSound("question", fileName: "question.aiff")
        Sounds.loadSound("key", fileName: "key.aiff")
        Sounds.loadSound("error", fileName: "error.aiff")
        Sounds.muteSound(!sounds)
    }
}
