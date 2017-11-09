function imName = fullPath2imageName(fullPath)
% Parses the full path of an image to get the image's name
% TODO: fix hardcode
[T,R] = strtok(fullPath, '\');
s1 = 'mad';
s2 = 'mur';
imName = [];

% Go through path until study name is found
while ~(strcmpi(T(1:length(s1)), s1) || strcmpi(T(1:length(s2)), s2))
    [T,R] = strtok(R, '\');
end

% Parse path into old name with folders separated by "="
while ~strcmpi(T(end-2:end), 'jpg')
    imName = [imName T '='];
    [T,R] = strtok(R, '\');
end

imName = [imName T];