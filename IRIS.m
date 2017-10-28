clear all;
close all;
clc;

%Allow user to choose image and convert to grayscale
filename = uigetfile();
RGB = imread(filename);
L = rgb2gray(RGB);

%Set min and max radius values
Rmin = 2;
Rmax = 40;

%Display image
subplot(2,2,1);
imshow(L);

%User crops the eyes using crop box
%https://uk.mathworks.com/help/images/cropping-an-image.html
Leyes = imcrop(L);

%Display cropped eyes
subplot(2,2,2);
imshow(Leyes);
hold on;

%Find dark circles in the cropped image
[centresD, radiiD] = imfindcircles(Leyes,[Rmin Rmax], 'objectPolarity', 'dark');

if length(radiiD) > 2
        % More than two circles found: find the two largest ones
        [~, ind] = sortrows([radiiD centresD]);
        ind = ind(end-1:end);
        radiiD = radiiD(ind);
        centresD = centresD(ind, :);
elseif length(radiiD) == 1
        % Only one circle found. This is the reason we check length(radii)
        % instead of length(centers). For this case, length(centers) == 2,
        % but it is a row vector with a single xy pair.
        fprintf(1, 'Only one circle found for i=%d (threshold=%.3g)\n', i, threshold);
end

%Plot the circles in red
viscircles(centresD, radiiD, 'Color', 'red');