% MATLAB program implementing a Gaussian Notch Reject Filter (GNRF)
% to remove periodic stripe noise from the assignment image 'Image1_PNoise.png'.
%
% The implementation follows the approach demonstrated in:
% https://www.youtube.com/watch?v=Ht37gT4hoy0
% I do not claim ownership of the original source code. All credit is given to
% this source for explaining the filtering concepts and serving as the
% primary reference for the method.
%
% An LLM (GPT-5) was used to assist in constructing the filter and to gain
% a broader understanding of how it works.
clc;
clear all;
close all;

a = imread('Image1_PNoise.png'); % Read the image 
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

sigma = 6;  % Notch width:

% Notch centers (offsets from the center of the spectrum).
u0 = [0 0];
v0 = [17 18];

% Build Gaussian Notch Reject Filter
H = ones(m,n);

for k = 1:length(u0)
    Hk = zeros(m,n);
    for u = 1:m
        for v = 1:n
            D1 = sqrt((u - m/2 - u0(k))^2 + (v - n/2 - v0(k))^2);
            D2 = sqrt((u - m/2 + u0(k))^2 + (v - n/2 + v0(k))^2);
            Hk(u,v) = (1 - exp(-(D1^2)/(2*sigma^2))) * ...
                      (1 - exp(-(D2^2)/(2*sigma^2)));
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
title('Gaussian Notch Reject Filter');

subplot(2,3,5);
mesh(H);
title('Surface plot GNRF');

subplot(2,3,6);
imshow(mat2gray(real(g)));
title('Gaussian notch filtered image');