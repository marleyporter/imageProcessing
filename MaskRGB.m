function maskedRGB = MaskRGB(skinImage, RGB)
% Mask image must be converted to the same integer type
% as the integer image we want to mask.
mask = cast(skinImage, class(RGB));

% Extract the individual red, green, and blue color planes.
redPlane = RGB(:, :, 1);
greenPlane = RGB(:, :, 2);
bluePlane = RGB(:, :, 3);

% Do the masking.
maskedRed = redPlane .* mask;
maskedGreen = greenPlane .* mask;
maskedBlue = bluePlane .* mask;

% Combine back into a masked RGB image.
maskedRGB = cat(3, maskedRed, maskedGreen, maskedBlue);
end