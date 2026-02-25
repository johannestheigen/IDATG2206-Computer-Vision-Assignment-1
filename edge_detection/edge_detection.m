% MATLAB program that performs Sobel-based edge detection on a video file.
% The script is based on the lab session on convolution for a single image
% and has been modified with the help of an AI assistant to process the video
% frame by frame and write each processed frame to a new output video.
clear all
clc
close all

input = 'Flowers.mp4'; % The input video file to read
output = 'Flowers_processed.mp4'; % The output video file.

v = VideoReader(input); % Read the video file to process
writer = VideoWriter(output, "MPEG-4");
writer.FrameRate = v.FrameRate;
open(writer);

% Process the video file frame by frame
while hasFrame(v)
    frame = readFrame(v); % Reads current frame to be processed
        
Agray = im2double(im2gray(frame)); % Convert the current frame to grayscale

% 3x3 Sobel filter kernel used for edge detection
K = [-1 -2 -1;
      0  0  0;
      1  2  1];

A_padded = padarray(Agray, [1 1], 0, 'both'); % Perform zero padding to perform convolution with 3x3 mask
K_flipped = rot90(K,2); % Rotate 180 degrees for convoution

[i, j] = size(A_padded); % Retrieves the size of they padded frame for loop limits

C = zeros(size(Agray)); % Output frame for edge results

% Performs convolution on the current frame 
for row = 2:(i-1)
    for col = 2:(j-1)
        sub = A_padded(row-1:row+1, col-1:col+1);
        C(row-1, col-1) = sum(sub .* K_flipped, 'all');
    end
end

writeVideo(writer, mat2gray(abs(C))); % Writes the processed frame to the output video

end

close(writer); % Closes the video writer object after processing is complete