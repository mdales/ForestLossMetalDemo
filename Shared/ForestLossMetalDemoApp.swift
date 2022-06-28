//
//  ForestLossMetalDemoApp.swift
//  Shared
//
//  Created by Michael Dales on 28/06/2022.
//

import SwiftUI

@main
struct ForestLossMetalDemoApp: App {
    @AppStorage("showBackground") private var showBackground = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            ToolbarCommands()
            CommandGroup(after: .toolbar) {
                Toggle(isOn: $showBackground) {
                    Text("Show background")
                }.keyboardShortcut("b", modifiers: [.command])
            }
        }
    }
}
