% Cleans the commandline and workspace before processing
clear all
clc
close all

video_file = 'Flowers.mp4'; % Variable used to store the file path of the .mp4 file
v = VideoReader(video_file); % Reads the mp4 file to be processed

while hasFrame(v) % Iterates through every frame contained within the .mp4 file
    rgbFrame = readFrame(v); % Reads current frame to be processed
        
Agray = double(im2gray(rgbFrame)); % Converts the current frame to grayscale

% 3x3 matrix that represents an image kernel used to apply different effects
K = [0 -1 0;
     -1 4 -1;
     0 -1 0];
A_padded = padarray(Agray, [1 1], 'replicate', 'both'); % Pads the current frame with zeros
K_flipped = rot90(K,2); % Rotates the kernel

[i, j] = size (A_padded); % Retrieves the size of the padded matrix

C = zeros(size(Agray)); % Initiates the output matrix with zeros, matching the size of the current grayscale frame. 

% Performs convolution on the current frame 
for row = 2:(i-1)
    for col = 2:(j-1)
        sub = A_padded(row-1:row+1, col-1:col+1);
        C(row-1, col-1) = sum(sub .* K_flipped, 'all');
    end
end

imshow(abs(C), []); % Displays the current processed frame
drawnow % Forces MATLAB to update the figure immediately.

end