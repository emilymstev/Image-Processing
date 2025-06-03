# Image-Processing

## Project Summary
This project implements an interactive image processing gallery in Processing. A single source image (dog.jpg) is passed through nine different filters and displayed in a 3x3 grid. Several filters change dymanically based on mouse movement.

## Filters included
* Brighten - Multiples RGB values by a factor to adjust brightness (interactive: mouseX)
* Negative - Inverts RGB values (255 - value)
* Binarize - Converts pixels to black or white based on brightness (interactive: mouseX)
* Posterize - Rounds RGB values to the nearest multiple (interactive: mouseX)
* Quantize - Reduces colors to a fixed number of random options (interactive: mouseX)
* Soften - Averages each pixel with its neighbors (81 todal) for a blur effect
* VerticalFlip - Flips the image upside down
* RotateClockwise - Rotates the image 90 degrees clockwise
* Shrink - Reduces the image to half size, centered in its cell

## Interactivity
Move the mouse left to right to control parameters of these filters
* Brighten - brightness factor from 0.0 to 5.0
* Binarize - threshold from 0 to 255
* Posterize - multiple from 1 to 255
* Quantize: number of color clusters from 1 to 100

## Files included
* imageProcessing.pde - The full sketch with all methods and display logic
* dog.jpg - The input image used in all filter demonstrations

## How to Run
Download Processing. Place imageProcessing.pde and dog.jpg in the same sketch folder. This can be done by going to "sketch" and "add File." Finally, run the sketch and move the mouse across the screen to explore the effects.
