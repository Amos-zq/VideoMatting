function [Priors_F, Priors_B ] = Priors( mask )
mask_curr = imresize(double(mask), 0.1);
h_1 = fspecial('gaussian', [10, 10], 1);
h_2 = fspecial('gaussian', [50, 50], 2);
mask_curr = imfilter(mask_curr, h_1, 'same', 'conv');
mask_curr = imresize(mask_curr, 10);
mask_curr = imfilter(mask_curr, h_2, 'same', 'conv');

mask_max = max(mask_curr(:));
mask_min = min(mask_curr(:));
mask_curr = (mask_curr - mask_min) ./ (mask_max - mask_min);
Priors_F = mask_curr;
Priors_B = 1 - mask_curr;
end

