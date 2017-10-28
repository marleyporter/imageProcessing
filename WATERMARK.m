clear all;
close all;
clc;

%User selects picture to watermark
filename = uigetfile();
originalImage = imread(filename);

%Convert image to grayscale
originalImage = rgb2gray(originalImage);

%Get and convert watermark to grayscale
verify = imread('waterm.png');
verify = rgb2gray(verify);

%Get the size of the original image and watermark image
[visibleRows, visibleColumns] = size(originalImage);
[hiddenRows, hiddenColumns] = size(verify);

%https://uk.mathworks.com/matlabcentral/answers/67364-how-can-i-watermark-an-image
% If image to be hidden is bigger than the original image, scale it down.
if hiddenRows > visibleRows || hiddenColumns > visibleColumns
	amountToShrink = min([visibleRows / hiddenRows, visibleColumns / hiddenColumns]);
	verify = imresize(verify, amountToShrink);
	% Need to update the number of rows and columns.
	[hiddenRows, hiddenColumns] = size(verify);
end
% Tile the hiddenImage, if it's smaller, so that it will cover the original image.
if hiddenRows < visibleRows || hiddenColumns < visibleColumns
	watermark = zeros(size(originalImage), 'uint8');
	for column = 1:visibleColumns
		for row = 1:visibleRows
			watermark(row, column) = verify(mod(row,hiddenRows)+1, mod(column,hiddenColumns)+1);
		end
	end
	% Crop it to the same size as the original image.
	watermark = watermark(1:visibleRows, 1:visibleColumns);
else
	% Watermark is the same size as the original image.
	watermark = verify;
end


%Get the 5th bit of the original image
originalbit = bitget(originalImage, 5);

%Add watermark to 5th bit set of original image
wmImage = bitset(originalImage, 5, watermark);

%Get the 5th bit set of the watermarked image
wmImage_5 = bitget(wmImage, 5);

%Remove watermark by replacing it with original bit
rmwmIm = bitset(wmImage, 5, originalbit);

%Get 5th bit set from image after watermark removal
rmwmbit = bitget(rmwmIm, 5);

subplot (3,2,1);
%Display original image
imagesc(originalImage);
colormap gray;
axis image; axis off;

subplot(3,2,2);
%Display watermark
imagesc(watermark);
axis image; axis off;

subplot(3,2,3);
%Display watermarked image
imagesc(wmImage);
axis image; axis off;

subplot(3,2,4);
%Display the 5th bit of the watermarked image
imagesc(wmImage_5);
axis image; axis off;

subplot(3,2,5);
%Display the original 5th bit
imagesc(originalbit);
axis image; axis off;

subplot(3,2,6);
%Display the image after removing the watermark
imagesc(rmwmIm);
axis image; axis off;
