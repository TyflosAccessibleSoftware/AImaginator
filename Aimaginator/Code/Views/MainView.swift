import SwiftUI
import SoundManager

struct MainView: View {
    @AppStorage("keyForAPI") var apiKey: String = ""
    @AppStorage("lastImageSize") var lastImageSize: DallEImageSize = .small
    @State var promptForAPIKey: String = ""
    @StateObject private var viewModel = MainViewModel()
    @State private var isApiKeyQuestion: Bool = false
    var body: some View {
        VStack {
            Group {
                HeaderView()
                Spacer()
            }
            if !viewModel.isAPIKeyError {
                Group {
                    if viewModel.ocrForImage != "" {
                        TextPanelView(text: viewModel.ocrForImage)
                    }
                    PictureFrameView(viewModel: viewModel)
                    BottomToolbarView(viewModel: viewModel)
                }
            } else {
                ApiErrorNotificationView(action: {
                    isApiKeyQuestion = true
                })
            }
        }
        .onAppear(perform: {
            // on startUp
            viewModel.imageSize = lastImageSize
            checkApiKey()
        })
        .sheet(isPresented: $isApiKeyQuestion, content: {
            VStack {
                Text("OpenAI API Key")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                Text("Please, type your API Key for OpenAI DALL-E service.")
                Link("Create your OpenAI account",
                     destination: URL(string: "https://beta.openai.com")!)
                HStack {
                    TextField("API Key:", text: $promptForAPIKey)
                    
                    Button("OK") {
                        Task {
                            self.isApiKeyQuestion = false
                            await self.viewModel.setAPIKey("\(promptForAPIKey)", completed: {
                                self.apiKey = viewModel.getApiKey()
                            })
                        }
                    }
                }
            }
        })
        .alert(isPresented: $viewModel.isError, content: {
            Alert(title: Text("OpenAI error"),
                  message: Text(viewModel.errorString),
                  dismissButton:
                    Alert.Button.default(Text("OK"), action: {
                viewModel.isError = false
            })
            )
            
        })
        
    }
    
    private func checkApiKey() {
        guard apiKey != "" else {
            viewModel.isAPIKeyError = true
            return
        }
        Task {
            await self.viewModel.setAPIKey("\(self.apiKey)", completed: {
                self.apiKey = viewModel.getApiKey()
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
