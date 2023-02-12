import SwiftUI

extension CIImage {
    var cgImage: CGImage? {
        let context = CIContext(options: nil)
        return context.createCGImage(self, from: self.extent)
    }
}
