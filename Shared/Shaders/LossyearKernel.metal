//
//  LossyearKernel.metal
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 28/06/2022.
//

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

    float4 my_shader(float4 pixel, float year) {
        if ((pixel.r > 0.0) and (pixel.r < year)) {
            return float4(1.0, 0.6, 0.6, 1.0);
        } else {
            return float4(0.0, 0.0, 0.0, 0.0);
        };
    }

}}

/*
     Bits of shader code used in interactive live coding demo:

     return pixel;

     return pixel * 200;

     return float4(1.0, 0.5, 0.5, 1.0);

     return float4(0.0, 0.0, 0.0, 0.0);

     return float4(year * 20, year * 20, year * 20, 1.0);

     if ((pixel.r > 0.0) and (pixel.r < year)) {
        return float4(1.0, 0.6, 0.6, 1.0);
     } else {
        return float4(0.0, 0.0, 0.0, 0.0);
     };
 */
