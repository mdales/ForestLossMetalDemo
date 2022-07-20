//
//  SaveImage.swift
//  ForestLossMetalDemo (macOS)
//
//  Created by Michael Dales on 20/07/2022.
//

import AppKit

func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.png]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save your image"
    savePanel.message = "Choose a folder and a name to store the image."
    savePanel.nameFieldLabel = "Image file name:"

    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
}
