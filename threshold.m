function skinImage = threshold(RGB)
%Declare threshold values
T1 = 100;
T2 = 180;
greenImage = RGB(:,:,2);
%Apply threshold values to green plane of image
skinImage = (greenImage>T1)&(greenImage<T2);
end
