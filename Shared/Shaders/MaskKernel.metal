//
//  MaskKernel.metal
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 28/06/2022.
//

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

    float4 mask_shader(float4 pixel) {
        if ((pixel.r > 0.0) && (pixel.r < (1.0/2000))) {
            return float4(0.0, 0.0, 0.0, 0.0);
        } else {
            return float4(0.0, 0.1, 0.2, 0.5);
        };
    }

}}
