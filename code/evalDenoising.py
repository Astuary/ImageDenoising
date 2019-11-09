# This code is part of:
#
#   CMPSCI 670: Computer Vision
#   University of Massachusetts, Amherst
#   Instructor: Subhransu Maji
#

import os
import time
import numpy as np
import matplotlib.pyplot as plt 
import sys
from utils import imread

im = imread('../data/denoising/saturn.png')
noise1 = imread('../data/denoising/saturn-noise1g.png')
noise2 = imread('../data/denoising/saturn-noise1sp.png')

error1 = ((im - noise1)**2).sum()
error2 = ((im - noise2)**2).sum()

print 'Input, Errors: {:.2f} {:.2f}'.format(error1, error2)

plt.figure(1)

plt.subplot(131)
plt.imshow(im)
plt.title('Input')

plt.subplot(132)
plt.imshow(noise1)
plt.title('SE {:.2f}'.format(error1))

plt.subplot(133)
plt.imshow(noise2)
plt.title('SE {:.2f}'.format(error2))

plt.show()

# Denoising algorithm (Gaussian filtering)

# Denoising algorithm (Median filtering)

# Denoising algorithm (Non-local means)
