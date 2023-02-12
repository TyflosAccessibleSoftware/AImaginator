import Combine
import SwiftUI
import OCRHelper

@MainActor final class MainViewModel: ObservableObject {
    private let urlSession: URLSession
    private var API_KEY: String = ""
    @Published public var isAPIKeyError : Bool = false
    @Published public var imageURL: URL?
    @Published public var imageDescription: String = ""
    @Published public var ocrForImage: String = ""
    @Published public var imageSize: DallEImageSize = .small
    @Published public var loadedImage: Image?
    @Published public var isAvailable: Bool = false
    @Published public var isError: Bool = false
    @Published public var errorString: String = ""
    @Published public var prompt: String = ""
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func getApiKey()-> String {
        return self.API_KEY
    }
    
    public func setAPIKey(_ key: String, completed: (()->Void)?) async {
        guard key != "" else {
            self.isAvailable = false
            self.isAPIKeyError = true
            self.API_KEY = ""
            return
        }
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        let dictionary: [String : Any] = [
            "model": "text-davinci-002",
            "temperature": 0,
            "max_tokens": 6,
            "prompt": "Say this is a test"
        ]
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(DallEModelResponse.self, from: data)
            if let errorData = model.errorData {
                self.isAvailable = false
                self.isError = true
                self.errorString = errorData.message!
                self.API_KEY = ""
            } else {
                self.API_KEY = key
                self.isError = false
                self.isAvailable = true
                self.isAPIKeyError = false
                self.errorString = ""
            }
            completed?()
        } catch {
            print(error.localizedDescription)
            self.isAvailable = false
            self.isError = true
            self.errorString = error.localizedDescription
            self.API_KEY = ""
        }
    }
    
    public func generateImage(withText text: String, numberOfImages: Int = 1) async {
        self.imageURL = nil
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(self.API_KEY)", forHTTPHeaderField: "Authorization")
        let dictionary: [String : Any] = [
            "n": numberOfImages,
            "size": "\(self.imageSize.rawValue)",
            "prompt": text
        ]
        self.isAvailable = false
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(DallEModelResponse.self, from: data)
            if let errorData = model.errorData {
                self.isAvailable = false
                self.isError = true
                self.errorString = errorData.message!
                return
            }
            DispatchQueue.main.async {
                self.isAvailable = true
                guard let firstModel = model.data!.first else {
                    return
                }
                self.imageDescription = text
                self.imageURL = URL(string: firstModel.url)
            }
        } catch {
            self.isAvailable = true
            print(error.localizedDescription)
            self.isError = true
            self.errorString = error.localizedDescription
        }
    }
    
    public func getOcrForLoadedImage() async {
        guard let url = imageURL else {
            self.ocrForImage = ""
            return
        }
        let ciImage = CIImage(contentsOf: url)
        guard let image = ciImage?.cgImage else { return }
        OCRHelper.recognize(cgImage: image, completed: { result, error in
            guard let result = result else {
                print(error!.localizedDescription)
                return
            }
            var stringResult = ""
            for item in result {
                stringResult = "\(stringResult)\n\(item)"
            }
            self.ocrForImage = stringResult
            print("OCR= \(self.ocrForImage)")
        })
    }
}
