//
//  LandsatKernel.metal
//  ForestLossMetalDemo
//
//  Created by Michael Dales on 01/07/2022.
//

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

    float4 landsat_shader(float4 pixel) {

        // This data is landsat data, and has the following channels as per:
        //     https://data.globalforestwatch.org/documents/gfw::tree-cover-loss/explore
        //
        // Red: Red visible spectrum
        // Green: Near Infra Red (good for showing vegitation)
        // Blue: Short Wave Infrared band 1
        // Alpha: Short Wave Infrared band 2
        //
        // For details of the bands see the landsat page:
        //     https://landsat.gsfc.nasa.gov/satellites/landsat-8/landsat-8-bands/ 
        //
        // This shader creates a false colour image that attempts to emphises vegitation density whilst
        // retaining land features from the red channel.

        return float4(
          (pixel.r * 2) + (pixel.a * 2 * 0.8),
          (pixel.r * 1.8) + (((pixel.a * 2 * 0.7) + (pixel.b * 0.5)) * (1.0 - pixel.g)),
          (pixel.r * 2) + (pixel.a * 2 * 0.5),
          1.0
        );
    }

}}
