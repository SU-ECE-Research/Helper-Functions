function createSets(folder)
%createSets creates sets for all images in one folder

% folder where all images from one year are stored (defined in main.m as a global variable)
global inputMainFolderName
% folder where all results will be stored (defined in main.m as a global variable)
global outputMainFolderName
% Maximum Set Size
global maxSetSize;

% full name of a folder where one month of images is stored
inputFolderName = [inputMainFolderName folder '\'];
% full name of a folder where all results will be stored
outputFolderName = [outputMainFolderName folder '\'];

% File name for set information
setInfoFileName = [outputFolderName 'setInfo.txt'];

% This is the threshold between the time stamps of two consecutive images.
% If the difference between the time stamps of two images are within this
% threshold, they will be grouped together for background calculation.
timeLapseThreshold = 90; % in seconds

% Get a list of camera trap image files
fileList = dir([inputFolderName '*.JPG']);
numIm = length(fileList); % number of images in the directory


% Sort the images in order of time they were taken
% Read time image was taken for all images in a directory
rejectedIm = [];
for i = 1 : numIm
    if fileList(i).bytes > 0
        try
            imInfo = imfinfo([inputFolderName fileList(i).name]);
            try
                timeVecCurrent(i) = datenum(imInfo.FileModDate, 'dd-mmm-yyyy HH:MM:SS');
            catch
                timeVecCurrent(i) = NaN;
                rejectedIm = [rejectedIm i];
                fprintf('rejected image: %s (i=%d)\n', fileList(i).name, i);
            end
        catch
           rejectedIm = [rejectedIm i];
           timeVecCurrent(i) = NaN;
           fprintf('rejected image: %s (i=%d)\n', fileList(i).name, i);
        end
    else
        rejectedIm = [rejectedIm i];
        timeVecCurrent(i) = NaN;
        fprintf('rejected image: %s (i=%d)\n', fileList(i).name, i);
    end
end
fileList(rejectedIm) = [];
timeVecCurrent(rejectedIm) = [];
[sortedTime, index] = sort(timeVecCurrent);
fileList = fileList(index);
numIm = length(fileList);


timeVecPrevious = zeros(1,6); % vector for holding the time stamp of a previous image file
setInfo = zeros(1, numIm); % variable for storing set information
k = 0; % since it is going to be increased in the loop below

% Assign images into sets
for i = 1 : numIm % for each image in the directory
    
    if setInfo(i) == 0 % if this image does not belong to a set yet
        
        % compare time between consecutive images
        imInfo = imfinfo([inputFolderName fileList(i).name]);
        timeVecCurrent = datevec(imInfo.FileModDate, 'dd-mmm-yyyy HH:MM:SS');
        timeDifference = etime(timeVecCurrent, timeVecPrevious);
        
        % if time difference between images exceeds timeLapseThreshold create new set
        % otherwise, add image to current set
        if (timeDifference > timeLapseThreshold)
            k = k + 1; % new set
        end
        
        setInfo(i) = k;   % for each image in the directory, save the
        % identification number of the set that the image belongs to
        timeVecPrevious = timeVecCurrent;
    end
end

% Number of sets
numSets = max(setInfo);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                       Split sets if they are too large
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
while i <= numSets
    % find the number of images in set i
    imIndex = find((setInfo == i));
    numIm = length(imIndex);
    % if the number of images in set i is larger than maximum size:
    if numIm > maxSetSize
        % split into two sets by assigning images from the first half
        % of this set to set numSets + 1 and from the second half of
        % the set to numSets + 2
        setSize1 = round(numIm/2);
        setSize2 = numIm - setSize1;
        
        setInfo(imIndex(1 : setSize1)) = numSets+1;
        setInfo(imIndex(setSize1+1 : end)) = numSets+2;
        
        numSets = numSets + 2;
    end
    i = i + 1;
end

% Make sure that we have consecutive set numbers
u = unique(setInfo);
for i = 1 : length(u)
    setInfo(setInfo == u(i)) = i;
end
numSets = max(setInfo);


% Save the set information to a file
%mkdir(outputMainFolderName);
mkdir(outputFolderName);

fileId = fopen(setInfoFileName, 'wt');
% write the total number of sets
fprintf(fileId, '%d\n', numSets);
for i = 1 : numSets
    % write the set number
    fprintf(fileId, '%d ', i);
    % write the number of images in this set
    imNum = find(setInfo == i);
    fprintf(fileId, '%d\n', length(imNum));
    for k = 1 : length(imNum)
        fprintf(fileId, '%s\n', fileList(imNum(k)).name);
    end
end
fclose(fileId);
