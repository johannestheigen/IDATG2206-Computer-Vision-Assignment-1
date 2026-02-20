% Matlab program for Butterworth Notch Reject Filter (BNRF) used to remove
% the a lot of the noise in the image 'Image2_PNoise.png' of provided in
% the assignment.
%
% It is based on the approach shown in: https://www.youtube.com/watch?v=Ht37gT4hoy0
% The LLM model GPT 5 was ued order to gain a broader understanding of 
% how the filter works and to properly set the filter up.
clc;
clear all;
close all;

a = imread('Image2_PNoise.png'); % Read the image 
a = rgb2gray(a);  % Convert the image to gray scale
a = im2double(a); % Convert the range of colors from 0-255 to 0-1
[m,n]=size(a); 
 
% Subplot of the image with noise
subplot(2,3,1);
imshow(a);
title('Image with noise');

A = fft2(a);    % Fourier transform of image
subplot(2,3,2);
imshow(uint8(abs(A)));
title('F.T. of i/p without shift');

A_shift = fftshift(A); % Shifting origin
A_real = abs(A_shift); % Magnitude of A_shift(Freq. domain repre.)
subplot(2,3,3)
imshow(uint8(A_real));
title('Frequency domain image');

D0 = 13;  % Notch radius 
n_order = 6; % Butterworth order

% Notch centers (offsets from the center of the spectrum).
u0 = [14 28 42 56 70 84]; 
v0 = [16 32 48 64 80 96];

% Build Butterworth Notch Reject Filter
H = ones(m,n);

for k = 1:length(u0)
    Hk = zeros(m,n);
    for u = 1:m
        for v = 1:n
            D1 = sqrt((u - m/2 - u0(k))^2 + (v - n/2 - v0(k))^2);
            D2 = sqrt((u - m/2 + u0(k))^2 + (v - n/2 + v0(k))^2);
            Hk(u,v) = 1 / (1 + ((D0^2)/((D1*D2)+eps))^n_order);
        end
    end
    H = H .* Hk;
end

% Apply filter in frequency domain
H_high = H .* A_shift;
H_high_shift = ifftshift(H_high);
H_high_image = ifft2(H_high_shift);

% Display filter and results
subplot(2,3,4);
imshow(H,[]);
title('Gaussian Notch Reject Filter');

subplot(2,3,5);
mesh(H);
title('Surface plot GNRF');

subplot(2,3,6);
imshow(abs(H_high_image),[]);
title('Gaussian Notch Filtered image');