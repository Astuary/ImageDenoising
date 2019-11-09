%% Get random tile co-ordinate pairs for the seed patch
x = floor(1 + rand(1,1) * (w - tileSize -1));
y = floor(1 + rand(1,1) * (h - tileSize -1));

% Get the seed patch
patch = im(x:x+tileSize-1, y:y+tileSize-1);
% Copy the random tile seed patch from source image to the top-left corner
im_patch(1:tileSize, 1:tileSize) = patch;
