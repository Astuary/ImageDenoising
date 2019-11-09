% Entry code for evaluating demosaicing algorithms
% The code loops over all images and methods, computes the error and
% displays them in a table.
% 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
close all;
clc;
% Load images
im = im2double(imread('../data/denoising/saturn.png'));
noise1 = im2double(imread('../data/denoising/saturn-noise1g.png'));
noise2 = im2double(imread('../data/denoising/saturn-noise1sp.png'));
%noise1 = im2double(imread('../data/denoising/saturn-noise2g.png'));
%noise2 = im2double(imread('../data/denoising/saturn-noise2sp.png'));

% Compute errors
error1 = sum(sum((im - noise1).^2));
error2 = sum(sum((im - noise2).^2));
fprintf('Input, Errors: %.2f %.2f\n', error1, error2)

% Display the images
figure(1);
subplot(1,3,1); imshow(im); title('Input');
subplot(1,3,2); imshow(noise1); title(sprintf('SE %.2f', error1));
subplot(1,3,3); imshow(noise2); title(sprintf('SE %.2f', error2));

%% Denoising algorithm (Gaussian filtering)

count = 1;
% Experiment with different values of standard deviation
for i = 1.85:0.01:1.95 
    % Give noisy image and std dev as parameters to gaussian filter to get a denoised image
    filtered3 = imgaussfilt(noise1, i);
    filtered4 = imgaussfilt(noise2, i);

    % Compute errors - SSD
    error3 = sum(sum((im - filtered3).^2));
    error4 = sum(sum((im - filtered4).^2));
    
    % Print results
    fprintf('Gaussian Filter Simga %.2f- Input, Errors: %.2f %.2f\n', i, error3, error4)
    
    %Display results
    figure(2);
    subplot(5, 8, count); imshow(filtered3); title(sprintf('SE %.2f', error3));
    figure(3);
    subplot(5, 8, count); imshow(filtered4); title(sprintf('SE %.2f', error4));
    count = count + 1;


%% Denoising algorithm (Median filtering)

% To find the std dev where there is least SSD
min5 = Inf; index_x5 = 0; index_y5 = 0;
min6 = Inf; index_x6 = 0; index_y6 = 0;

% Experiment with different filter kernel dimensions 
for i = 1:10 
    for j = 1:10
        
        % Convolute noisy image with i x j dimension median filter kernel 
        filtered5 = medfilt2(noise1, [i, j]);
        filtered6 = medfilt2(noise2, [i, j]);

        % Compute errors - SSD
        error5 = sum(sum((im - filtered5).^2));
        error6 = sum(sum((im - filtered6).^2));
        fprintf('Median Filter Neighborhood %d %d- Input, Errors: %.2f %.2f\n', i, j, error5, error6)
        
        % Save the filter dimensions of the kernel with the least error
        if error5 < min5
            min5 = error5;
            index_x5 = i;
            index_y5 = j;
        end
        if error6 < min6
            min6 = error6;
            index_x6 = i;
            index_y6 = j;
        end
    end
end

% Print the results
fprintf('Median Filter Neighborhood %d %d- image1, Error: %.2f\n', index_x5, index_y5, min5)
fprintf('Median Filter Neighborhood %d %d- image2, Error: %.2f\n', index_x6, index_y6, min6)

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