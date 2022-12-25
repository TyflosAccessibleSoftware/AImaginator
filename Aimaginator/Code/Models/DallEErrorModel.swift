import SwiftUI

struct DallEError: Decodable {
    let code: String?
    let message: String?
    let param: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case param = "param"
        case type = "type"
    }
}
