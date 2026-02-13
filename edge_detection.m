clear all
clc
close all

A = imread("tux.png");
Agray = double(rgb2gray(A));

K = [-1 -1 -1; 
     -1  8 -1; 
     -1  -1 -1];

A_padded = padarray(Agray, [1 1], 0, 'both');

K_flipped = rot90(K,2); 

[i, j] = size (A_padded);
[n, m] = size (K);

C = zeros(size(Agray));

for row = 2:(i-1)
    for col = 2:(j-1)
        sub = A_padded(row-1:row+1, col-1:col+1);
        C(row-1, col-1) = sum(sub .* K_flipped, 'all');
    end
end

imshow(C, [])