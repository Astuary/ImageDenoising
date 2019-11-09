close;

% Load images
% im = im2double(imread('../data/texture/D20.png'));
% im = im2double(imread('../data/texture/Texture2.bmp'));
 im = im2double(imread('../data/texture/english.jpg'));

figure(1); imshow(im);


%% Random patches
tileSize = 40;  % specify block sizes - 15 20 30 40
numTiles = 5;
outSize = numTiles * tileSize; % calculate output image size
% save the random-patch output and record run-times
im_patch = synthRandomPatch(im, tileSize, numTiles, outSize);  
figure;
imshow(im_patch);

%% Non-parametric Texture Synthesis using Efros & Leung algorithm  
winsize = 11;  % specify window size (5, 7, 11, 15)
outSize = 70;  % specify size of the output image to be synthesized (square for simplicity)
% save the synthesized image and record the run-times
im_synth = synthEfrosLeung(im, winsize, outSize); 
figure(3);
imshow(im_synth);

%% Image Quilting
tileSize = 40;  % specify block sizes - 15 20 30 40
numTiles = 5;
outSize = numTiles * tileSize; % calculate output image size
% save the random-patch output and record run-times
im_patch = synthImageQuilting(im, tileSize, numTiles, outSize);  
figure;
imshow(im_patch);

