function maskedErRGB = ErodeRGB(erImage, RGB)
%Seperate RGB into planes
redPlane = RGB(:,:,1);
greenPlane = RGB(:,:,2);
bluePlane = RGB(:,:,3);
%Create mask
maskEr = cast(erImage, class(RGB));
%Multiply each plane by mask
maskedErRed = redPlane .* maskEr;
maskedErGreen = greenPlane .* maskEr;
maskedErBlue = bluePlane .* maskEr;
%Concatonate planes together
maskedErRGB = cat (3, maskedErRed, maskedErGreen, maskedErBlue);
end