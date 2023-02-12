import SwiftUI
import SoundManager

struct BottomToolbarView: View {
    @StateObject public var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            TextField("Describe the image that you want to generate",
                      text: $viewModel.prompt,
                      axis: .vertical)
            .lineLimit(10)
            .lineSpacing(5)
            .padding(5)
            .onChange(of: viewModel.prompt, perform: { value in
                Sounds.playSound("key")
            })
            Spacer()
            Picker("Image size", selection: $viewModel.imageSize) {
                ForEach(DallEImageSize.elements , id: \.self) {
                    Text("\($0.rawValue)")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 10)
            Button("Create") {
                Sounds.playSound("question")
                Task {
                    await viewModel.generateImage(withText: viewModel.prompt)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .disabled(!viewModel.prompt.isEmpty && viewModel.isAvailable && !viewModel.isAPIKeyError ? false : true)
            
            Button("Read") {
                Sounds.playSound("question")
                Task {
                    await viewModel.getOcrForLoadedImage()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .disabled((viewModel.loadedImage != nil && viewModel.isAvailable && viewModel.imageURL != nil) ? false : true)
            
            Button("Save") {
                Sounds.playSound("question")
                if let urlToSave = showSavePanel(viewModel.prompt), let imageUrl = viewModel.imageURL {
                    let errorSaving = savePNG(url: imageUrl, path: urlToSave)
                    if let errorSaving = errorSaving {
                        viewModel.errorString = errorSaving.localizedDescription
                        viewModel.isError = true
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .disabled((viewModel.loadedImage != nil && viewModel.isAvailable && viewModel.imageURL != nil) ? false : true)
            
        }
    }
}

struct BottomToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomToolbarView(viewModel: MainViewModel())
    }
}
