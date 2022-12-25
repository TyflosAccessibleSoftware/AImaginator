import SwiftUI

struct DallEModelResponse: Decodable {
    let data: [DallEImageUrlResponse]?
    let errorData: DallEError?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case errorData = "error"
    }
}
