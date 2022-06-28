//
//  MaskFilter.swift
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 28/06/2022.
//

import MetalKit

class MaskFilter: CIFilter {
    private let kernel: CIColorKernel

    var inputImage: CIImage?

    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        kernel = try! CIColorKernel(functionName: "mask_shader", fromMetalLibraryData: data)
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var outputImage: CIImage? {
        guard let inputImage = self.inputImage else { return nil }
        let inputExtent = inputImage.extent

        let roiCallback: CIKernelROICallback = { _, rect -> CGRect in
            return rect
        }
        return self.kernel.apply(extent: inputExtent,
                                 roiCallback: roiCallback,
                                 arguments: [inputImage])
    }


}
