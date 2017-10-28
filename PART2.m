clear all;
close all;
clc;

%Allow user to select image
filename = uigetfile();

%Save selected image to RGB variable
RGB = imread(filename);

%Get M and N values of RGB image
M = size(RGB, 1);
N = size(RGB, 2);

figure;

%============================= (a)
subplot(4,3,1);

%Call thresholding function
[skinImage] = threshold(RGB);

%Display thresholded image (binary)
imagesc(skinImage);

colormap gray;
axis off;
axis image;

%============================== (b)
subplot(4,3,[2,3]);

T1 = 120;
T2 = 180;

%Seperate the color planes of RGB image and save to variables
[rows, columns, colours] = size(RGB);
redPlane = RGB(:,:,1);
greenPlane = RGB(:,:,2);
bluePlane = RGB(:,:,3);

%Display count histogram of red plane as a red line 
[pixelCountR, valueR] = imhist(redPlane);
plot(pixelCountR, 'r');
hold on;

%Display count histogram of green plane as a green line
[pixelCountG, valueG] = imhist(greenPlane);
plot(pixelCountG, 'g');
hold on;

%Display count histogram of blue plane as a blue line
[pixelCountB, valueB] = imhist(bluePlane);
plot(pixelCountB, 'b');

%Set x and y axis limits
xlim([0 255]);
ylim([0 max([pixelCountR; pixelCountG; pixelCountB])]);
hold on;

%Display threshold values as green vertical line on value used
plot([T1,T1], [0, max([pixelCountR; pixelCountG; pixelCountB])], ...
    'g:', 'Linewidth', 3);
plot([T2,T2], [0, max([pixelCountR; pixelCountG; pixelCountB])], ...
    'g:', 'Linewidth', 3);

%Label x and y axis
xlabel('Luminance');
ylabel('Count');

%Display legend explaining the meaning of each line
legend('Red Values' , 'Green Values' , 'Blue Values', 'Location', 'northwest');


%================================ (c)
subplot(4,3,4);

%Call masking function
[maskedRGB] = MaskRGB(skinImage, RGB);

%Display masked RGB image
imagesc(maskedRGB); 

axis off;
axis image;


%================================= (d)
subplot(4,3,5);

%Call morphological eroding function
[erImage] = ErodeIm(skinImage);

%Display eroded image (binary)
imagesc(erImage);

colormap gray;
axis off;
axis image;


%=================================== (e)
subplot(4,3,6);

%Call masked eroded RGB image function
[maskedErRGB] = ErodeRGB(erImage, RGB);

%Display eroded RGB image
imagesc(maskedErRGB);

axis off;
axis image;

%==================================== (f)
subplot(4,3,7);

%Call morphological closing function
[clImage] = CloseIm(erImage);

%Display closed image (binary)
imagesc(clImage);

colormap gray;
axis off;
axis image;

%==================================== (g)
subplot(4,3,8);

%Call masked closed RGB image function
[maskedClRGB] = CloseRGB(clImage, RGB);

%Display masked closed RGB image
imagesc(maskedClRGB);

axis off;
axis image;

%==================================== (h)
subplot(4,3,9);

%Display RGB image
imagesc(RGB);
hold on;

%
labeledImage = bwlabel(clImage);
measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
for k = 1 : length(measurements)
  thisBB = measurements(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)], ...
        'EdgeColor','b','LineWidth',2 )
end

axis off;
axis image;

%===================================== (i)
subplot(4,3,10.3);

%Canny edge detection of the closed binary image
G1 = edge(clImage, 'canny');

%Dilate the canny edge image
G2 = imdilate(G1, strel('disk', 8));

%Display dilated canny edge image
imagesc(G2);

axis off;
axis image;

%====================================== (j)
subplot(4,3,11.7);

%Save boundaries of the closed binary image
b = bwboundaries(clImage);

%Display RGB image
imagesc(RGB);
hold on;

%Plot the boundaries of the closed binary image on the RGB image with a 
%yellow line
plot(b{1}(:,2), b{1}(:,1), 'y', 'Linewidth', 2);

axis off;
axis image;
