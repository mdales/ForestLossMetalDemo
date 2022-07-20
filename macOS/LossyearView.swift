//
//  LossyearView.swift
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 28/06/2022.
//

import SwiftUI
import MetalKit

struct LossyearView: NSViewRepresentable {
    @EnvironmentObject private var model: ImageCompositionModel

    func makeCoordinator() -> Coordinator {
        Coordinator(self, model: model)
    }

    func makeNSView(context: NSViewRepresentableContext<LossyearView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0.0, alpha: 0.0)
        mtkView.autoResizeDrawable = true
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = true
        return mtkView
    }

    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<LossyearView>) {
        nsView.setNeedsDisplay(nsView.frame)
    }
}
