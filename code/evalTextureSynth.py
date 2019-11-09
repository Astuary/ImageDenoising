import numpy as np
from skimage import io

# Load images
img = io.imread('../data/texture/D20.png')
# img = io.imread('../data/texture/Texture2.bmp')
# img = io.imread('../data/texture/english.jpg')


# Random patches
tileSize = 30 # specify block sizes
numTiles = 5
outSize = numTiles * tileSize # calculate output image size
# implement the following, save the random-patch output and record run-times
im_patch = synthRandomPatch(im, tileSize, numTiles, outSize)


# Non-parametric Texture Synthesis using Efros & Leung algorithm  
winsize = 11 # specify window size (5, 7, 11, 15)
outSize = 70 # specify size of the output image to be synthesized (square for simplicity)
# implement the following, save the synthesized image and record the run-times
im_synth = synthEfrosLeung(im, winsize, outSize)

