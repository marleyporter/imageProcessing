clear all;
close all;
clc;

%Allow user to select image
filename = uigetfile();
%Save selcted image to RGB variable
RGB = imread(filename);

%RGB to grayscale image
L = 0.2126 * RGB(:,:,1) + 0.7152 * RGB(:,:,2) + 0.0722 * RGB(:,:,3);

%Get max and min values of grayscale image
Lmin = min(min(L));
Lmax = max(max(L));

%===========================================(a)
subplot(4,3,1);

%Set top and bottom values
t=255;
b=0;

%Apply stretch formula to grayscale image
Lstretch = ((L-Lmin)*((t-b)/(Lmax-Lmin)));

%Display stretched image
imagesc(Lstretch);

colormap gray;
axis off;
axis image;

%============================================(b)
subplot(4,3,[2,3]);

%Calculate count histogram of grayscale and stretched image
counthL = imhist(L);
counthLs = imhist(Lstretch);

%Display count histograms with lines on same graph
plot([0:255], counthL, 'r-');
hold on;
plot([0:255], counthLs, 'b-');

%Label x and y axis
xlabel('Luminance');
ylabel('Count');

%Set x and y limits
xlim([0;255]); ylim([0 max(counthL)]);

%Display legend explaining the meaning of each line
legend('L before stretch' , 'L after stretch' , 'Location', 'northwest');

%============================================(c)
subplot(4,3,4);

%Histogram eqaulization of grayscale image
histE = histeq(L,256);

%Display equalised image
imagesc(histE);

colormap gray;
axis off;
axis image;

%============================================(d)
subplot(4,3,[5,6]);

%Calculate count histogram of equalised image
counthS = imhist(histE);

%Display count histogram of grayscale and equalised image
plot([0:255], counthL, 'r-');
hold on;
plot([0:255], counthS, 'b-');

%Label x and y axis
xlabel('Luminance');
ylabel('Count');

%Set x and y axis limits
xlim([0;255]); ylim([0 max(counthL)]);

%Display legend explaining the meaning of each line
legend('L before equalization' , 'L after equalization' , 'Location', 'northwest');

%===========================================(e)
subplot(4,3,7);

%Call the functions used in part 2 to get face area
[skinImage] = threshold(RGB);
[erImage] = ErodeIm(skinImage);
[clImage] = CloseIm(erImage);
[maskedClRGB] = CloseRGB(clImage, RGB);

%Stretch of the face area
stretchface = imadjust(maskedClRGB, stretchlim(maskedClRGB), []);

%Create mask of face
holemaker = clImage * 255;

%Seperate RGB image into planes and subtract the mask of the face
rHole = RGB(:,:,1) - uint8(holemaker);
gHole = RGB(:,:,2) - uint8(holemaker);
bHole = RGB(:,:,3) - uint8(holemaker);
 
%Concatonate rgb planes back together
rgbHole = cat(3, rHole, gHole, bHole);

%Add the stretched face to RGB image with face hole
stretchedface = rgbHole + stretchface;

%Display final image
imagesc(stretchedface);

axis off;
axis image;

%===========================================(f)
subplot(4,3,8);

%Change RGB face image to HSV format
face_hsv = rgb2hsv(maskedClRGB);

%Seperate HSV into planes
face_h = face_hsv(:,:,1);
face_s = face_hsv(:,:,2);
face_v = face_hsv(:,:,3);

%Histogram equalisation of value plane of HSV image
face_v = histeq(face_v);

%Concatonate planes back together
facehsv = cat(3, face_h, face_s, face_v);

%Change HSV image to RGB format
eqface = hsv2rgb(facehsv);

%Display equalised face
imagesc(eqface);

colormap gray;
axis off;
axis image;

%===========================================(g)
subplot(4,3,9);

%Sharpen grayscale image using unsharp masking method
unsh = imsharpen(L);

%Display sharpened image
imagesc(unsh);

colormap gray;
axis off;
axis image;

%===========================================(h)
subplot(4,3,10);

%Create 3x3 filter
kernel = [-1, -1, -1; -1, 17, -1; -1, -1, -1]/9;

%Sharpen grayscale image using sharpen convolution filter
sh = conv2(double(L), kernel, 'same');

%Display sharpened image
imagesc(sh);

colormap gray;
axis off;
axis image;

%===========================================(i)
subplot(4,3,11);

%Add 10% salt and pepper noise to the grayscale image
salpep = imnoise(L, 'salt & pepper', 0.1);

%Display salt and pepper image
imagesc(salpep);

colormap gray;
axis off;
axis image;

%============================================(j)
subplot(4,3,12);

%Apply median filter to salt and pepper image
medfil = medfilt2(salpep, [3,3]);

%Display median filtered image
imagesc(medfil);

colormap gray;
axis off;
axis image;

