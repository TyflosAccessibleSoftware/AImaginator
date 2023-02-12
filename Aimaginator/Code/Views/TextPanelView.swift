import SwiftUI
import SoundManager

struct TextPanelView: View {
    var text: String
    var body: some View {
        Text(text)
            .background(.white)
            .foregroundColor(.black)
            .border(.black, width: 2)
            .padding(5)
            .onAppear {
                Sounds.playSound("complete")
            }
    }
}

struct TextPanelView_Previews: PreviewProvider {
    static var previews: some View {
        TextPanelView(text: "")
    }
}
