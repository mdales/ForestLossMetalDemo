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

    var yearFilter: LossyearFilter
    var scaleFilter: CIFilter
    var combineFilter: CIFilter

    var maskFilter: MaskFilter
    var backgroundExposureFilter: CIFilter
    var backgroundContrastFilter: CIFilter
    var backgroundCombineFilter: CIFilter
    var backgroundTameFilter: CIFilter

    var maskImage: CIImage
    var backgroundImage: CIImage
    var lossyearImage: CIImage

    var colorSpace: CGColorSpace

    var showBackground: Bool = true

    init(_ parent: LossyearView) {
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
            self.context = CIContext(mtlDevice: metalDevice)
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()!

        maskImage = CIImage(contentsOf: Bundle.main.url(forResource: "datamask", withExtension: "tiff")!)!
        lossyearImage = CIImage(contentsOf: Bundle.main.url(forResource: "lossyear", withExtension: "tiff")!)!
        backgroundImage = CIImage(contentsOf: Bundle.main.url(forResource: "background_raw", withExtension: "tif")!)!

        maskFilter = MaskFilter()
        maskFilter.inputImage = maskImage

        backgroundExposureFilter = CIFilter(name: "CIExposureAdjust")!
        backgroundExposureFilter.setValue(backgroundImage, forKey: kCIInputImageKey)
        backgroundExposureFilter.setValue(4, forKey: kCIInputEVKey)

        backgroundContrastFilter = CIFilter(name: "CIGammaAdjust")!
        backgroundContrastFilter.setValue(backgroundExposureFilter.outputImage!, forKey: kCIInputImageKey)
        backgroundContrastFilter.setValue(1.4, forKey: "inputPower")

        backgroundCombineFilter = CIFilter(name: "CISourceOverCompositing")!
        backgroundCombineFilter.setValue(maskFilter.outputImage!, forKey: kCIInputBackgroundImageKey)
        backgroundCombineFilter.setValue(backgroundContrastFilter.outputImage, forKey: kCIInputImageKey)

        backgroundTameFilter = CIFilter(name: "CIExposureAdjust")!
        backgroundTameFilter.setValue(backgroundCombineFilter.outputImage!, forKey: kCIInputImageKey)
        backgroundTameFilter.setValue(-0.8, forKey: kCIInputEVKey)

        yearFilter = LossyearFilter()
        yearFilter.inputImage = lossyearImage
        yearFilter.year = 20

        combineFilter = CIFilter(name: "CISourceOverCompositing")!
        combineFilter.setValue(backgroundTameFilter.outputImage!, forKey: kCIInputBackgroundImageKey)

        scaleFilter = CIFilter(name: "CILanczosScaleTransform")!

        colorSpace = CGColorSpaceCreateDeviceRGB()

        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        view.setNeedsDisplay(view.frame)
    }

    public func draw(in view: MTKView) {
        if let currentDrawable = view.currentDrawable {

            let xscale = view.drawableSize.width / lossyearImage.extent.width
            let yscale = view.drawableSize.height / lossyearImage.extent.height
            let scale = min(xscale, yscale)
            if scale == 0.0 {
                return
            }

            let commandBuffer = metalCommandQueue.makeCommandBuffer()

            combineFilter.setValue(yearFilter.outputImage!, forKey: kCIInputImageKey)

            if showBackground {
                scaleFilter.setValue(combineFilter.outputImage!, forKey: kCIInputImageKey)
            } else {
                scaleFilter.setValue(yearFilter.outputImage!, forKey: kCIInputImageKey)
            }
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
