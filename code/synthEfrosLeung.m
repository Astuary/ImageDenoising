function im_synth = synthEfrosLeung(im, winsize, outSize)
    %% Initializing output/synthesized image with all -1 (not with 0s as they might depict an actual value) 
    im_synth = zeros(outSize)-1;
    % Maximum number of pixels which might need to get their values interpolated
    n = outSize * outSize;
    
    % Get half window size 
    halfWinSize = floor(winsize/2);
    % Error Threshold for finding best matches to interpolate a pixel's value
    error_thresold = 0.1;
    
    %% Get input image size
    [w, h, c] = size(im);
    
    % Randomly choose a pixel value co-ordinate pair; "-3" shows we must choose the pixel in a way that a 3 x 3 patch with this pixel at top-left is possible 
    x = floor(1 + rand(1,1) * (w - 3 - 1));
    y = floor(1 + rand(1,1) * (h - 3 - 1));
    % A 3x3 SEED PATCH
    patch = im(x:x+3-1, y:y+3-1);
    
    % Copy the seed patch to the center of the output/synthesized image
    im_synth(outSize/2-1:outSize/2+1, outSize/2-1:outSize/2+1) = patch;
    
    %% Growing the borders of the filled pixels in the output image
    for k = 1:outSize*outSize 
        %% list of pixel positions in the output image that are unfilled, but contain filled pixels in their neighbourhood
        pixelList = zeros(n, 3);
        count = 1;
        
        % For all pixels of the output/synthesized image  
        for i = 1:outSize
           for j = 1:outSize
               flag = 0;
               
               % For any pixel whose value has yet to be calculated
               if im_synth(i, j) == -1
                   % Add it to the list but...
                   pixelList(count, 1) = i;
                   pixelList(count, 2) = j;

                   % Identify how many of its 8 neighbors have their values interpolated already
                   % Add the #neighbors_having_valid_values to the pixelList frequency counter
                   if i + 1 <= outSize && im_synth(i+1, j) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if i - 1 >= 1 && im_synth(i-1, j) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if j + 1 <= outSize && im_synth(i, j+1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if j - 1 >= 1 && im_synth(i, j-1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if i + 1 <= outSize && j - 1 >= 1 && im_synth(i+1, j-1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if i - 1 >= 1 && j - 1 >= 1 && im_synth(i-1, j-1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if i + 1 <= outSize && j + 1 <= outSize && im_synth(i+1, j+1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   if i - 1 >= 1 && j + 1 <= outSize && im_synth(i-1, j+1) ~= -1
                       flag = 1;
                       pixelList(count, 3) = pixelList(count, 3) + 1;
                   end
                   
                   % If the output pixel has at least one neighbor having valid value, only then that pixel would count
                   if flag == 1
                       count = count + 1;
                   end
               end
           end
        end
        
        %% Now we have a list of all the pixels whose values we will interpolate in this pass
        pixelList = pixelList(1:count-1,:);
        % Sort the list by the number of filled neighboorhood pixels
        pixelList = sortrows(pixelList, 3, 'descend');
        
        %% For each pixel in pixelList 
        for p = 1:size(pixelList, 1)
            % Initialize SSD to maximum integer
            ssd_min = Inf;
            
            %% Initialize a validMask of windowSize x windowSize 
            validMask = im_synth(max(1, pixelList(p, 1) - halfWinSize): min(outSize, pixelList(p, 1) + halfWinSize), max(1, pixelList(p, 2) - halfWinSize): min(outSize, pixelList(p, 2) + halfWinSize));
            % 1s at the neighboorhood positions of that pixel that contains filled pixels 
            validMask(validMask ~= -1) = 1;
            % 0s for unfilled positions 
            validMask(validMask == -1) = 0;
            
            % Get a patch of windowSize x windowSize around the pixel whose value we need to find
            patch1 = im_synth(max(1, pixelList(p, 1) - halfWinSize): min(outSize, pixelList(p, 1) + halfWinSize), max(1, pixelList(p, 2) - halfWinSize): min(outSize, pixelList(p, 2) + halfWinSize)).*validMask;
            
            %% For every patch in the input image, compare it with the patch we got for the pixel we want to compute
            for x = 1:w-winsize
                for y = 1:h-winsize
                    if size(im(x:x+winsize-1,y:y+winsize-1)) == size(validMask)
                        % Apply Valid Mask
                        patch2 = im(x:x+winsize-1,y:y+winsize-1).*validMask;
                        if size(patch1) == size(patch2)
                            % Find the minimum SSD 
                            dist = (patch1 - patch2);
                            ssd = sum(dist(:).^2);  
                        end
                        % Find the pixels in the input image have a similar neighbourhood w.r.t. the filled neighbours of the currently unfilled pixel in the output image
                        if ssd < ssd_min
                            % Get minimum SSD
                            ssd_min = ssd;
                            patch3 = im(x:x+winsize-1,y:y+winsize-1);
                        end
                    end
                end
            end
            
            %% Get the best matches 
            bestMatches = zeros(w*h, 1);
            count1 = 1;
            for x = 1:w
                for y = 1:h
                    pix = im(x, y);
                    if ssd_min*(1+error_thresold) >= pix
                        bestMatches(count1, 1) = pix;
                        count1 = count1 + 1;
                    end 
                end
            end
            
            %% Randomly pick an input image pixel from BestMatches and paste its pixel value into the current unfilled output pixel location
            im_synth(pixelList(p, 1), pixelList(p, 2)) = bestMatches(randperm(size(bestMatches, 1), 1), 1);
                     
        end 
    end     
end