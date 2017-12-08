# generating-cartoon-images
This repository tells you how to create cartoon images in MATLAB using edge detection and coloring each regions using mean color of regions and gray scale intensity.

STEP Involved
RGB Image is converted to grayscale image for furture processing.
First Edge Detection in carried out on the grayscale using 'Canny' edge detection filter.
Result of above operation is a binary image.
Then edges are dilated to form connected regions.
Then regions of smaller area are merged with their neighbours.
Once we have all the regions (area between edges), we obtain the mean color corresponding to that region from the original RGB image.
We fill each region with that color and apply some gradient using grayscale intensities
We color the edges black.
Result is a cartoonized version of the original image.
All these were done in MATLAB using in-built functions.
