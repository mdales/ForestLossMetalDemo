//
//  ForestLossMetalDemoApp.swift
//  Shared
//
//  Created by Michael Dales on 28/06/2022.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct ForestLossMetalDemoApp: App {
    @AppStorage("showBackground") private var showBackground = true
    private let model = ImageCompositionModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .commands {
            ToolbarCommands()
            CommandGroup(after: .newItem) {
                Button("Save image...") {
                   if let url = showSavePanel(),
                      let image = model.renderOutput(),
                      let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)
                    {
                       CGImageDestinationAddImage(destination, image, nil)
                       CGImageDestinationFinalize(destination)
                    }
                }.keyboardShortcut("s", modifiers: [.command])
            }
            CommandGroup(after: .toolbar) {
                Toggle(isOn: $showBackground) {
                    Text("Show background")
                }.keyboardShortcut("b", modifiers: [.command])
            }
        }
    }
}
