function setInfo = get_setInfo(filePath, defName)
% Returns setInfo struct array giving information about a set's nonunique 
% number, the number of images in it, and the image names
%{

Input:
- filePath (to the setInfo.txt you wish to see)
- [OPTIONAL] defName (name of .txt file you want to use, if not 'setInfo'
or 'setInfo2'

Output:
- setInfo (struct array)



% Author: Joshua Beard
% Contributors: Taz Bales-Heisterkamp
% C: 11/22/16
% E: 1/20/17 
    1/16/17: Handle images with .jpg as well as .JPG (TBH)
    1/20/17: Comments and variable name change for clarity (JB)
%}
%% As of 1/7/16, This section is probably unnecessary. 
% Intended for compatibility with CREATESETS.
% The next section handles it more simply.
% Keeping this part in case of new naming convention
if(nargin < 2)
    %% This section handles multiple types of setInfo files
    txtFileDir = dir([filePath '\*.txt']);
    if(length(txtFileDir) > 1)
        warning(['Multiple .txt files exist in ' filePath '. Opening setInfo.txt.']);
        cpfn = [filePath '\setInfo.txt'];
    else
        cpfn = [filePath '\' txtFileDir.name];
    end
else
    cpfn = [filePath '\' defName '.txt'];
end




% Open file with read permission only
fid = fopen(cpfn,'r');

if(fid == -1)
    error(['Could not open file at: ' cpfn]);

else    
    % Prototype of struct
    setInfo = struct('set', 0, 'nImgs', 0, 'names', cell(1),'note',[]);
    nSets = fgetl(fid);
    setN = 0;
    imgNum = 0;
    % Stop when end of file is reached
    while(~feof(fid))
        thisLine = fgetl(fid);
        % Check if line is image name
        if(strcmp(upper(thisLine(end-2:end)), 'JPG')) % changed 1/16 by TBH
            % If line is image name, store it in 'names' field
            imgNum = imgNum+1;
            setInfo(setN).names{imgNum} = thisLine;
        else
            % If line is set info line, get set # and # images and store them
            setN = setN+1;
            [s n] = strtok(thisLine);
            setInfo(setN).set = str2num(s);
            setInfo(setN).nImgs = str2num(n);
            imgNum = 0;
        end
    end
end

% Close it up
if(fclose(fid) < 0)
    error(['Could not close file at: ' cpfn]);
end

