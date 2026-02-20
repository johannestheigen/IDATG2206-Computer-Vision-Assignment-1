% Matlab program for a Butterworth Notch Reject Filter (BNRF) used to remove
% periodic noise in the assignment image 'Image2_PNoise.png'.
%
% The implementation follows the approach demonstrated in:
% https://www.youtube.com/watch?v=Ht37gT4hoy0
% I do not claim ownership of the original source code; credit is given to
% this source for explaining the filtering concepts and serving as the
% primary reference for the method.
%
% An LLM (GPT-5) was used to assist in constructing the filter and to gain
% a broader understanding of how it works.
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

% Apply filter in frequency domain and return to spatial domain
G = H .* A_shift;
G_ishift = ifftshift(G);
g = ifft2(G_ishift);

subplot(2,3,4);
imshow(H,[]);
title('Butterworth Notch Reject Filter');

subplot(2,3,5);
mesh(H);
title('Surface plot BNRF');

subplot(2,3,6);
imshow(mat2gray(real(g)));
title('Butterworth notch filtered image');