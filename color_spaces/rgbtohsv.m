% MATLAB program that converts an image from RGB to CIELAB.
% The part displaying the individual color channels was developed
% with the assistance of AI

% Read an RGB image
rgbImage = imread('tz.png');

% Convert the entire image to Lab
labImage = rgb2lab(rgbImage);

% Extract individual channels
L = labImage(:,:,1); % Luminosity
a = labImage(:,:,2); % Red-Green
b = labImage(:,:,3); % Blue-Yellow

% Display the original RGB image and the different color channels of the
subplot(2,2,1);
imshow(rgbImage);
title('Original RGB');

subplot(2,2,2);
imshow(L, []); colorbar;
title('Lightness (L*)');

subplot(2,2,3);
imshow(a, []); colorbar;
title('Red–Green (a*)');

subplot(2,2,4);
imshow(b, []); colorbar;
title('Blue–Yellow (b*)');