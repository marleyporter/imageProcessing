function maskedClRGB = CloseRGB(clImage, RGB)

%Seperate RGB into planes
redPlane = RGB(:,:,1);
greenPlane = RGB(:,:,2);
bluePlane = RGB(:,:,3);
%Create mask
maskCl = cast(clImage, class(RGB));

%Multiply each plane by mask
maskedClRed = redPlane .* maskCl;
maskedClGreen = greenPlane .* maskCl;
maskedClBlue = bluePlane .* maskCl;

%Concatonate planes together
maskedClRGB = cat(3, maskedClRed, maskedClGreen, maskedClBlue);
end