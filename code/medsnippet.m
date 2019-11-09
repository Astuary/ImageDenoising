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