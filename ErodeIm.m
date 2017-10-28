function erImage = ErodeIm(skinImage)
%Morphological erosion of the image
SE = strel('disk', 20);
erImage = imerode(skinImage, SE);
end