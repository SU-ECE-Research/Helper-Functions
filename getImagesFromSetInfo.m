function [X, r, c] = getImagesFromSetInfo(imageFolder, setInfo, setNum)
% Creates a matrix of DxN, where:
    % D = image size (in pixels)  
    % N = number of images in set
% Images are of values in range [0, 255] 
%{
Joshua Beard
C: 1/21/17
E: 1/21/17
%}

for(q = 1:length(setInfo(setNum).names))
     temp = uint8(rgb2gray(imread(pathJoin(imageFolder, setInfo(setNum).names{q}))));
     X(:,q) = temp(:);
end
[r, c] = size(temp);