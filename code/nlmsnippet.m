%% Denoising alogirthm (Non-local means)

img_n = noise1;     % Noisy Image
halfPatchSize = 2;  % Patch Size (halved)       
windowHalfSearchSize = 10;  % Window Size (halved)       
gamma = 0.01;       % Bandwidth parameter
[w, h] = size(img_n);  % Size of the noisy image 

img_f = img_n;      % Denoised Image

% Go through whole image 
for i = 1:h
    for j = 1:w
        
        % Get the patch with the pixel (i, j) as its center and halfPatchSize as its radius
        px = img_n(max(1, j - halfPatchSize):min(w, j + halfPatchSize), max(1, i - halfPatchSize):min(h, i + halfPatchSize));
        
        % nominator of the denoised pixel equation
        sum_up = 0.0;
        % denominator of the denoised pixel equation
        sum_dn = 0.0;
        
        % For each pixel on vertical edges of the window specified by its half size
        for k = max(1, j - windowHalfSearchSize):min(w, j + windowHalfSearchSize)
            
            % For left edge of the window
            if 1 <= i - windowHalfSearchSize
                % Get a patch around that particular pixel on the left edge of the window 
                py = img_n(max(1, k - halfPatchSize):min(w, k + halfPatchSize), max(1, i - windowHalfSearchSize - halfPatchSize):min(h, i - windowHalfSearchSize + halfPatchSize)); 
                % Find out minimum SSD
                if size(px) == size(py)
                    s = (px - py).^2;
                    s = s(:);
                    d = sqrt(sum(s)); 
                    d1 = exp(-1 * gamma * d);
                    sum_dn = sum_dn + d1;
                    sum_up = sum_up + d1 * img_n(j, i);
                end
            end
            
            % For right edge of the window
            if h >= i + windowHalfSearchSize
                % Get a patch around that particular pixel on the right edge of the window
                py = img_n(max(1, k - halfPatchSize):min(w, k + halfPatchSize), max(1, i + windowHalfSearchSize - halfPatchSize):min(h, i + windowHalfSearchSize + halfPatchSize)); 
                % Find out minimum SSD
                if size(px) == size(py)
                    s = (px - py).^2;
                    s = s(:);
                    d = sqrt(sum(s)); 
                    d1 = exp(-1 * gamma * d);
                    sum_dn = sum_dn + d1;
                    sum_up = sum_up + d1 * img_n(j, i);
                end
            end
        end
        
        % For each pixel on horizontal edges of the window specified by its half size
        for k = max(1, i - windowHalfSearchSize):min(h, i + windowHalfSearchSize)
            % For top edge of the window
            if 1 <= j - windowHalfSearchSize
                % Get a patch around that particular pixel on the upper edge of the window
                py = img_n(max(1, j - windowHalfSearchSize - halfPatchSize):min(w, j - windowHalfSearchSize + halfPatchSize), max(1, k - halfPatchSize):min(h, k + halfPatchSize)); 
                % Find out minimum SSD
                if size(px) == size(py)
                    s = (px - py).^2;
                    s = s(:);
                    d = sqrt(sum(s)); 
                    d1 = exp(-1 * gamma * d);
                    sum_dn = sum_dn + d1;
                    sum_up = sum_up + d1 * img_n(j, i);
                end
            end
            
            % For bottom edge of the window
            if w >= j + windowHalfSearchSize   
                % Get a patch around that particular pixel on the lower edge of the window
                py = img_n(max(1, j + windowHalfSearchSize - halfPatchSize):min(w, j + windowHalfSearchSize + halfPatchSize), max(1, k - halfPatchSize):min(h, k + halfPatchSize)); 
                % Find out minimum SSD
                if size(px) == size(py)
                    s = (px - py).^2;
                    s = s(:);
                    d = sqrt(sum(s)); 
                    d1 = exp(-1 * gamma * d);
                    sum_dn = sum_dn + d1;
                    sum_up = sum_up + d1 * img_n(j, i);
                end
            end
        end
        
        % Get the new value for the pixel (i, j)
        if sum_dn ~= 0
            img_f(j, i) = sum_up/sum_dn;
            disp(img_f(j,i))
        end
        
    end
end

% Caluclate Error - SSD
error7 = sum(sum((im - img_f).^2));
% Print the error
fprintf('Non-Linear Means Errors: %.6f\n', error7)
% Show the results
figure;
subplot(121); imshow(im);
subplot(122); imshow(img_f);