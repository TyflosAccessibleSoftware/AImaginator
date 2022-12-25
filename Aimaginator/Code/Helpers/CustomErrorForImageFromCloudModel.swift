import Foundation

public enum CustomErrorForImageFromCloud : Error {
    case imageNotDownloaded
    case imageNotSaved
}

extension CustomErrorForImageFromCloud: LocalizedError {
    public var  errorDescription: String? {
        switch self {
        case .imageNotDownloaded:
            return NSLocalizedString("The image could not be downloaded from the Cloud", comment: "")
        case .imageNotSaved:
            return NSLocalizedString("The image could not be saved", comment: "")
        }
    }
}
