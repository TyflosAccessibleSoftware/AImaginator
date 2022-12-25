import SwiftUI
import SoundManager

struct PictureFrameView: View {
    @StateObject public var viewModel: MainViewModel
    
    var body: some View {
        Section {
            AsyncImage(url: viewModel.imageURL) { imageFromCloud in
                imageFromCloud
                    .resizable()
                    .scaledToFit()
                    .accessibilityHidden(false)
                    .accessibilityLabel(Text("\(self.viewModel.prompt)"))
                    .accessibilityHint(Text("Press Vo+shift+l to read a description of the image using VoiceOver's image recognition"))
                    .onAppear(perform: {
                        self.viewModel.loadedImage = imageFromCloud
                        Sounds.playSound("complete")
                    })
            } placeholder: {
                if !self.viewModel.isAvailable {
                    ProgressView()
                        .padding(.bottom, 12)
                    Text("Creating the image. Please wait...")
                        .multilineTextAlignment(.center)
                } else if self.viewModel.imageURL == nil {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                        .accessibilityLabel(Text("Empty image"))
                }
            }
            .frame(width: 512, height: 512)
        }
    }
}

struct PictureFrameView_Previews: PreviewProvider {
    static var previews: some View {
        PictureFrameView(viewModel: MainViewModel())
    }
}
