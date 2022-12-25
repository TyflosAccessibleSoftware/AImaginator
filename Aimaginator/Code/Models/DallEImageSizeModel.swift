import SwiftUI

enum DallEImageSize : String {
    case small = "256x256"
    case medium = "512x512"
    case big = "1024x1024"
    
    static var elements: [DallEImageSize] {
        return [.small, .medium, .big]
    }
}
