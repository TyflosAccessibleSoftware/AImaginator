import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("AImaginator")
                .font(.title)
                .accessibilityAddTraits(.isHeader)
            Text("A basic tool to create awesome images")
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
