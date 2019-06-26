# cautious-chainsaw
IHS and Brovey pan-sharpening methods in matlab.

Function takes a multispectral image and a panchromatic image as an input, then proceeds to run two different pan sharpening methods: 
brovey and intensity saturation hue (IHS).

This function only accepts a three band multispectral image as an input. If the pancromatic image has three bands, 
the function will only use one of the bands. 

Outputs are stored in two variables, B for brovey and I for the IHS. 
