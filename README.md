#  ForestLossMetalDemo

## Summary

This is a simple demonstration of using Metal shader code to you you visualise geospacial data without first turning the data into an image meant for human consumption. There are three source images used in this demo: a mask image, a Landsat satellite image (which has red and multiple infrared channels), and a final image that contains year of forest loss. None of these images are designed for direct human viewing, but with custom shaders we can do that conversion at display time on the GPU.

## Code license

The source code for this project is released in the public domain. See UNLICENSE file for details.

## Data source

This demo contains three GEOTIFF images from the Global Forest Watch "Hansen" dataset, which can be found here:

https://glad.earthengine.app/view/global-forest-change

This data is provided by Hansen/UMD/Google/USGS/NASA under the following license:

> This work is licensed under a Creative Commons Attribution 4.0 International License. You are free to copy and redistribute the material in any medium or format, and to transform and build upon the material for any purpose, even commercially. You must give appropriate credit, provide a link to the license, and indicate if changes were made.
