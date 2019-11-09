function im_patch = synthRandomPatch(im, tileSize, numTiles, outSize)
    
    % Get size of original image whose texture we want to synthesize
    [w, h] = size(im);
    
    % Initialize output/ result to the size specified
    im_patch = zeros(outSize);
    
    % Create a synthesized image block-by-block or tile-by-tile 
    for i = 1:numTiles
        for j = 1:numTiles
            
            % Randomly selects an x-axis as a top-left corner of a random tile
            x = floor(1 + rand(1,1) * (w - tileSize -1));
            % Randomly selects an y-axis as a top-left corner of a random tile
            y = floor(1 + rand(1,1) * (h - tileSize -1));

            % Cut out the copy of the tile
            patch = im(x:x+tileSize-1, y:y+tileSize-1);
            % Paste it in the assigned top-left corner of the output image
            % [Top to Bottom; Left to Right]
            im_patch((i-1)*tileSize+1:(i-1)*tileSize+tileSize, (j-1)*tileSize+1:(j-1)*tileSize+tileSize) = patch;
        end
    end
end