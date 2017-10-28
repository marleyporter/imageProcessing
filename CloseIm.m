function clImage = CloseIm(erImage)
%Morphological closing of image
SEcl = strel('disk', 300);
clImage = imclose(erImage, SEcl);
end