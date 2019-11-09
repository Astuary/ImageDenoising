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
end