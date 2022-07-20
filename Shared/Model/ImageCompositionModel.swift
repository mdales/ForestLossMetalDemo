//
//  ImageCompositionModel.swift
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 20/07/2022.
//

import Foundation
import MetalKit
import SwiftUI

class ImageCompositionModel: ObservableObject {

    private let maskImage: CIImage
    private let backgroundImage: CIImage
    private let lossyearImage: CIImage

    private let yearFilter: LossyearFilter
    private let combineFilter: CIFilter
    private let maskFilter: SimpleFilter
    private let landsatFilter:SimpleFilter
    private let backgroundCombineFilter: CIFilter

    @AppStorage("showBackground") private var showBackground = true
    @Published var year: Double = 2000

    init() {
        maskImage = CIImage(contentsOf: Bundle.main.url(forResource: "datamask", withExtension: "tiff")!)!
        lossyearImage = CIImage(contentsOf: Bundle.main.url(forResource: "lossyear", withExtension: "tiff")!)!
        backgroundImage = CIImage(contentsOf: Bundle.main.url(forResource: "last", withExtension: "tiff")!)!

        maskFilter = SimpleFilter(functionName: "mask_shader")
        maskFilter.inputImage = maskImage

        landsatFilter = SimpleFilter(functionName: "landsat_shader")
        landsatFilter.inputImage = backgroundImage

        backgroundCombineFilter = CIFilter(name: "CISourceOverCompositing")!
        backgroundCombineFilter.setValue(landsatFilter.outputImage!, forKey: kCIInputBackgroundImageKey)
        backgroundCombineFilter.setValue(maskFilter.outputImage, forKey: kCIInputImageKey)

        yearFilter = LossyearFilter()
        yearFilter.inputImage = lossyearImage
        yearFilter.year = 20

        combineFilter = CIFilter(name: "CISourceOverCompositing")!
        combineFilter.setValue(backgroundCombineFilter.outputImage!, forKey: kCIInputBackgroundImageKey)
    }

    var getOutputImage: CIImage? {
        // In theory I could combine this, so we update the value
        // on filter as it updates, but it's also only needed at this point
        yearFilter.year = year

        if showBackground {
            // Note that unless I do the setValue here, combineFilter doesn't refresh
            // unlike yearfilter. I assume there's some caching or CIFilter assumes
            // inputs aren't dynamic - there is probably a better way to prod it than this
            // I'd imagine
            combineFilter.setValue(yearFilter.outputImage!, forKey: kCIInputImageKey)
            return combineFilter.outputImage
        } else {
            return yearFilter.outputImage
        }
    }

    func renderOutput() -> CGImage? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        guard let image = getOutputImage else {
            return nil
        }

        let context = CIContext.init(mtlDevice: device)
        return context.createCGImage(image, from: CGRect(x: 0, y: 0, width: image.extent.size.width, height: image.extent.size.height))
    }
}
