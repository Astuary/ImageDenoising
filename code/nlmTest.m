function nlmTest

    % parameters
    sigma = 0.3;                % noise std
    halfPatchSize = 3;          % half size of the patch
    windowSearchHalfSize = 6;   % half size for searching the neighbors
    N_n = 16;                   % numer of neighbors
    h = 0.3 * sigma^2;          % nlm filtering parameter

    im = im2double(imread('../data/denoising/saturn.png'));
    noise1 = im2double(imread('../data/denoising/saturn-noise1g.png'));
    noise2 = im2double(imread('../data/denoising/saturn-noise1sp.png'));
    noise3 = im2double(imread('../data/denoising/saturn-noise2g.png'));
    noise4 = im2double(imread('../data/denoising/saturn-noise2sp.png'));
    img_n = noise4;
    
    
    % denoise (nn, offset = 0)
    offset = 0;
    img_f_nn = nlm(img_n, halfPatchSize, windowSearchHalfSize, N_n, sigma, h, offset);
    
    % denoise (snn, offset = 0.8)
    offset = 0.8;
    img_f_snn = nlm(img_n, halfPatchSize, windowSearchHalfSize, N_n, sigma, h, offset);
    
    % errors
    mse_n = sum(sum((im(:)-img_n(:)).^2));
    mse_nn = sum(sum((im(:)-img_f_nn(:)).^2));
    mse_snn = sum(sum((im(:)-img_f_snn(:)).^2));

    figure(1);
    clf;
    subplot(221);
    imshow(im);
    title('Image');
    subplot(222);
    imshow(img_n);
    title(['Noisy image - MSE = ' num2str(mse_n)]);
    subplot(223);
    imshow(img_f_nn);
    title(['Filtered image [NN] - MSE = ' num2str(mse_nn)]);
    subplot(224);
    imshow(img_f_snn);
    title(['Filtered image [SNN] - MSE = ' num2str(mse_snn)]);

    figure;
    imshow(img_f_nn);
end