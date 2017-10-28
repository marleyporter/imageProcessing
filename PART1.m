clear all;
close all;
clc;

filename = uigetfile(); %Allow the user to select image
RGB = imread(filename); %Save selected image to RGB variable

figure;

%========================= (a) Original RGB Image(RGB)
subplot(4,3,1);

%Display RGB image
imagesc(RGB);
axis off;
axis image;


%========================= (b) Grayscale Image(L)
subplot(4,3,2);
%Convert RGB image to grayscale
L = 0.2126 * RGB(:,:,1) + 0.7152 * RGB(:,:,2) + 0.0722 * RGB(:,:,3);
%Display grayscale image
imagesc(L);

colormap gray;
axis off;
axis image;


%========================= (c) 
subplot(4,3,3);

%Get the M and N values of image
M = size(RGB,1);
N = size(RGB,2);

%Calculate the size of rgb, grayscale and binary image
sizergb = 3 * M * N;
sizeL = M * N;
sizeB = (M * N) / 8;

%Save output text to variables
textmn = sprintf('M = %s , N =%s', num2str(M),num2str(N));
textrgb = sprintf('RGB size = %s', num2str(sizergb));
textl = sprintf('L size = %s', num2str(sizeL));
textb = sprintf('B size = %s', num2str(sizeB));

%Display text
text(0.0, 0.55, textmn);
text(0.0, 0.4, textrgb);
text(0.0, 0.25, textl);
text(0.0, 0.1, textb);
axis off;
axis image;

%========================== (d)
subplot(4,3,4);
%Set the min and max lum values to variables
minLum = min(min(L));
maxLum = max(max(L));

%Set minLum(i,j) to variables
[h,k]=min(L);
[value,i]=min(h);
mincolomn=i;
minrow=k(i);

%Set  maxLum(i,j) to variables
[y,d]=max(L);
[value2,p]=max(y);
maxcolomn=p;
maxrow=d(p);

%Calculate cityblock value
cityblock = abs(minrow - maxrow) + abs(mincolomn - maxcolomn);
%Calculate euclidean value
euclidean = sqrt((minrow - maxrow)^2 + (mincolomn - maxcolomn)^2);
%Calculate mean value
textmean = mean2(L);

%Using variables to store the output text
minmaxL = sprintf('L_{min} (%s,%s) = %s and L_{max} (%s,%s) = %s', ... 
    num2str(minrow), num2str(mincolomn), num2str(minLum),num2str(maxrow), ... 
        num2str(maxcolomn), num2str(maxLum));
city = sprintf('City block distance between L_{min} and L_{max} = %s', ...
     num2str(cityblock));
eucl = sprintf('Euclidean distance between L_{min} and L_{max} = %s', ...
     num2str(euclidean));
mean = sprintf('Lmean = %s', num2str(textmean));

%Display the text in the specified location
text(0.0, 0.55, minmaxL);
text(0.0, 0.4, city);
text(0.0, 0.25, eucl);
text(0.0, 0.1, mean);

axis off;


%=========================== (e)
subplot(4,3,5);

%Set binary threshold to 128
threshold = 128/256;

%Convert L to binary
B = im2bw(L,threshold);

%Display binary image
imagesc(B);

%Show the location of the maximum (red circle) and minimum value (green 
%circle) pixels on the binary image
hold on;
plot(maxcolomn, maxrow, 'ro');
plot(mincolomn, minrow, 'go');

colormap gray;

axis off;
axis image;


%=========================== (f)
subplot(4,3,6);
%Calculate the contrast range
crange = abs(maxLum - minLum);

%Calculate the normalised contrast range
cnrange = crange / 256;

%Calculate the Michelson contrast
cmich = (maxLum - minLum)/(maxLum + minLum);

%Calculate the RMS contrast
S = 81;
lminuss = L-S;
sqlms = lminuss.^2;
sumsqlms = sum(sum(sqlms));
sumpix = M*N;
crms = sqrt((1/sumpix) * sumsqlms);

%Using variables to store the output text
textcr = sprintf('C _{range} of L = %s', num2str(crange));
textcnr = sprintf('C _{normRange} of L = %s', num2str(cnrange));
textcm = sprintf('C _{mich} of L = %s', num2str(cmich));
textcrms = sprintf('C _{rms} of L = %s', num2str(crms));


%Display the text in the specified location
text(0.0, 0.55, textcr);
text(0.0, 0.4, textcnr);
text(0.0, 0.25, textcm);
text(0.0, 0.1, textcrms);

axis off;


%============================ (g)
subplot(4,3,7.3);

%Calculate the count histogram of L
counth = imhist(L);

%Display the count histogram as bar chart
bar([0:255], counth, 'r');

%Label x and y axis
xlabel('Luminance');
ylabel('Count');

%Set x and y axis limits
xlim([0;255]); ylim([0 max(counth)]);


%============================= (h)
subplot(4,3,8.7);

%Display normalised count histogram as bar chart
bar([0:255], counth/sumpix, 'r');

%Label x and y axis
xlabel('Luminance');
ylabel('Normalised Count');

%Set x and y axis limits
xlim([0;255]); ylim([0 max(counth/sumpix)]);

%============================== (i)
subplot(4,3,10.3);

%Cycle through the pixel values summing the count of the pixels to
%cumulh (Cumulative count histogram)
for currentLum = 1:256
    cumulh(currentLum) = sum(counth(1:currentLum));
end

%Display cumalative count histogram
bar([0:255], cumulh, 'r'); 

%Label x and y axis
xlabel('Luminance');
ylabel('Cumulative Count');

%Set x and y axis limits
xlim ([0;255]); ylim([0;sumpix]);

%=============================== (j)
subplot(4,3,11.7);

%Display normalised cumulative count histogram as bar chart
bar([0:255], cumulh/sumpix, 'r');

%Label x and y axis
xlabel('Luminance');
ylabel('Normalised Cumulative Count');

%Set x and y axis limits
xlim([0;255]); ylim([0;1]);

