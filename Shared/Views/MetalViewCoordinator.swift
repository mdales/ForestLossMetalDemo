//
//  MetalViewCoordinator.swift
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 28/06/2022.
//

import Foundation
import MetalKit

class Coordinator : NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var context : CIContext?

    let model: ImageCompositionModel

    var scaleFilter: CIFilter
    var colorSpace: CGColorSpace

    init(_ parent: LossyearView, model: ImageCompositionModel) {
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
            self.context = CIContext(mtlDevice: metalDevice)
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()!
        self.model = model

        scaleFilter = CIFilter(name: "CILanczosScaleTransform")!

        colorSpace = CGColorSpaceCreateDeviceRGB()

        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        view.setNeedsDisplay(view.frame)
    }

    public func draw(in view: MTKView) {
        if let currentDrawable = view.currentDrawable {

            guard let outputImage = model.getOutputImage else {
                return
            }

            let xscale = view.drawableSize.width / outputImage.extent.width
            let yscale = view.drawableSize.height / outputImage.extent.height
            let scale = min(xscale, yscale)
            if scale == 0.0 {
                return
            }

            let commandBuffer = metalCommandQueue.makeCommandBuffer()

            scaleFilter.setValue(outputImage, forKey: kCIInputImageKey)
            scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
            guard let outputImage = scaleFilter.outputImage else {
                return
            }

            context!.render(outputImage,
                            to: currentDrawable.texture,
                            commandBuffer: commandBuffer,
                            bounds: CGRect(origin: .zero, size: view.drawableSize),
                            colorSpace: colorSpace)

            commandBuffer?.present(currentDrawable)
            commandBuffer?.commit()
        }
    }
}
