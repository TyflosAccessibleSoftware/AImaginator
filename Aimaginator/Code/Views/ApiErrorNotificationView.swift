import SwiftUI
import SoundManager

struct ApiErrorNotificationView: View {
    var action: (()->Void)?
    var body: some View {
        Text("OpenAI API Key error")
            .font(.title)
            .accessibilityAddTraits(.isHeader)
            .onAppear(perform: {
                Sounds.playSound("error")
            })
        Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .accessibilityHidden(true)
        Text("The API Key for OpenAI is not valid")
            .multilineTextAlignment(.center)
        Button("Set API key") {
            action?()
        }
    }
}

struct ApiErrorNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ApiErrorNotificationView()
    }
}
