function im_patch = synthImageQuilting(im, tileSize, numTiles, outSize)
    %% Get the dimensions of the input image
    [w, h, c] = size(im);
    
    %% Initialize the output image with all 0s
    im_patch = zeros(outSize);
    
    %% Get random tile co-ordinate pairs for the seed patch
    x = floor(1 + rand(1,1) * (w - tileSize -1));
    y = floor(1 + rand(1,1) * (h - tileSize -1));
    
    % Get the seed patch
    patch = im(x:x+tileSize-1, y:y+tileSize-1);
    % Copy the random tile seed patch from source image to the top-left corner
    im_patch(1:tileSize, 1:tileSize) = patch;
    
    %% size of the region of overlap between tiles - typically 1/6
    overlap = ceil(1/6 * tileSize);
    
    %% For each tile of the output/synthesized image
    for i = 1:numTiles
        for j = 1:numTiles
            
            % Do nothing for the first tile as it is already set by the random patch
            if (i == 1 && j == 1)
               continue; 
            end
            
            ssd_C_min = inf;
            ssd_D_min = inf;
            
            %% SSD (sum of squared difference) between the neighbors of the output image tile position and each tile position in the source image, considering the region of overlap
            for m = 1 : w - tileSize
                for n = 1 :h - tileSize
                    temp_patch = im(m:m+tileSize-1, n:n+tileSize-1);
                    
                    % Upper Horizontal overlapping section
                    A = temp_patch(1:tileSize, 1:overlap);
                    % Left Vertical overlapping section
                    B = temp_patch(1:overlap, 1:tileSize);
                    
                    if (i ~= 1 && j ~= 1)
                        C = im_patch((i-1)*tileSize+1:(i-1)*tileSize+tileSize, (j-1)*tileSize-overlap:(j-1)*tileSize-1);
                        diff = A - C;
                        ssd_C = sum(sum(diff(:).^2));
                        D = im_patch((i-1)*tileSize-overlap:(i-1)*tileSize-1, (j-1)*tileSize+1:(j-1)*tileSize+tileSize);
                        diff = B - D;
                        ssd_D = sum(sum(diff(:).^2));
                        if ssd_C + ssd_D < ssd_C_min + ssd_D_min
                            patch = temp_patch;
                            ssd_C_min = ssd_C;
                            ssd_D_min = ssd_D;
                        end
                    elseif(i ~= 1)
                        D = im_patch((i-1)*tileSize-overlap:(i-1)*tileSize-1, (j-1)*tileSize+1:(j-1)*tileSize+tileSize);
                        diff = B - D;
                        ssd_D = sum(sum(diff(:).^2));
                        
                        if ssd_D < ssd_D_min
                            patch = temp_patch;
                            ssd_D_min = ssd_D;
                        end
                    elseif(j ~= 1)
                        C = im_patch((i-1)*tileSize+1:(i-1)*tileSize+tileSize, (j-1)*tileSize-overlap:(j-1)*tileSize-1);
                        diff = A - C;
                        ssd_C = sum(sum(diff(:).^2));
                        
                        if ssd_C < ssd_C_min
                            patch = temp_patch;
                            ssd_C_min = ssd_C;
                        end   
                    end
                        
                end
            end

            %% Copy the tile in source image with lowest SSD (minSSD) with respect to the current tile in output image, to the output image
            im_patch((i-1)*tileSize+1:(i-1)*tileSize+tileSize, (j-1)*tileSize+1:(j-1)*tileSize+tileSize) = patch;
        
            %% To the next un-filled position in the output image (left-to-right, top-to-bottom)
        end
    end
    
end