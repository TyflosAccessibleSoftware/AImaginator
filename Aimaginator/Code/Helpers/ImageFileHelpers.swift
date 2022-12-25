import SwiftUI

func showSavePanel(_ fileName: String)-> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.png]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = NSLocalizedString("Save the image", comment: "")
    savePanel.message = NSLocalizedString("Choose a folder and a name to store the image.", comment: "")
    savePanel.nameFieldLabel = NSLocalizedString("Image file name:", comment: "")
    savePanel.nameFieldStringValue = "\(fileName)"
    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
}

func savePNG(url: URL, path: URL)-> Error? {
    do {
        
        let image = NSImage(contentsOf: url)
        guard let image = image else {
            let customError = CustomErrorForImageFromCloud.imageNotDownloaded
            return customError
        }
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        guard let imageRepresentation = imageRepresentation else {
            let customError = CustomErrorForImageFromCloud.imageNotSaved
            return customError
        }
        let pngData = imageRepresentation.representation(using: .png, properties: [:])
        try pngData!.write(to: path)
    } catch {
        print(error)
        return error
    }
    return nil
}
