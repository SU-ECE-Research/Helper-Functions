function image = vec2gray(vec, r, c)
% Converts a vector into a grayscale image
%{
PARAMETERS:
- vec: vector to be transformed (len(vec) == r*c)
- r: rows in image
- c: columns in image

Joshua Beard
C: 12/24/16
E: 12/24/16
%}
image = mat2gray(reshape(vec, r, c));
