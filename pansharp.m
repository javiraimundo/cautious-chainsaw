function [B, I] = pansharp(P, M)
%Checks if P is one dim array, cuts it otherwise
    if ismatrix(P)
        return
    else
        P = P(:,:,1);
    end

%Checks to make sure the Multi image is upscaled to the PAN    
	[rowsP,colsP] = size(P);
	[rowsM,colsM] = size(M);


    if rowsP ~= rowsM || colsP ~= colsM
        M = imresize(M, [rowsP colsP], 'bilinear');
    end

%__________________________________________________________________________
%Begin IHS Method to be stored in varible I
% Convert PAN to double 
    pan = double(P);

% Convert RGB to HSV 
    hsv = rgb2hsv(M);

% Calculate the standard deviations and means for the pan image and 
% the intensity band 
    devpan = std2(pan);
    devmulti = std2(hsv(:,:,3));
    meanpan = mean2(pan);
    meanmulti = mean2(hsv(:,:,3));

% Match the pancromatic and intensity through brightness and contrast  
    hsv(:,:,3) = (pan - meanpan) * (devmulti/devpan) + meanmulti;

%Convert hsv back to rgb and convert from double to uint8
    %t = hsv2rgb(hsv);
    I = im2uint8((hsv2rgb(hsv)));
    
%__________________________________________________________________________
%Begin Brovey Method to be stored in B
% Convert from uint8 to double     
    MULTI_432 = double(M);
    PAN = double(P);

% Get the dimensions of the MS image    
    [~, ~, d_im] = size(MULTI_432);
% Sum of all the bands for each pixel    
    Band_sum = sum(MULTI_432, 3); 
    B = zeros(size(MULTI_432));
    
%Apply Brovey Transformation    
    for i = 1:1:d_im
            B = d_im.*(MULTI_432./Band_sum).*PAN;
    end

%Convert variable B back to uint8    
    B = uint8(B);
    
    
%__________________________________________________________________________
%Show the two versions of pansharpening 
figure;
ax1 = subplot(1,2,1);
imshow(uint8(I)), axis equal, axis tight;
title('IHS');

ax2 = subplot(1,2,2);
imshow(uint8(B)), axis equal, axis tight;
title('Brovey');

linkaxes([ax1,ax2],'xy')
end 

