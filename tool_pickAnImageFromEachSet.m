%{
Tool for picking an image from each set without having to navigate to each
folder in File Explorer

Author: Joshua Beard
C: 1/20/17
E: 1/21/17
%}

%% Parameters
clear all; close all;
%parentFolder = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Murghab_Concession\';
parentFolder = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Madiyan_Pshart\';
folderListName = 'spotFolderList';
%folderListName = 'folderList';
%folderListName = 'rpcaPriorityFolders';
%dataFolder = '\\ecefs1\ECE_Research-Space-Share\DATA\Tajikistan_2012_CTPhotos\Murghab_Concession\';
dataFolder = '\\ecefs1\ECE_Research-Space-Share\DATA\Tajikistan_2012_CTPhotos\Madiyan_Pshart\';
saveFolder = '\\ecefs1\ECE_Research-Space-Share\Spot Sampling\Negatives\';
%% Initialization
load([parentFolder folderListName]);
folderList = eval(folderListName);

done = false;
folderNum = 0;
while ~done
    folderNum = folderNum + 1;
    
    % Get path for this folder
    thisFolder = [parentFolder folderList(folderNum).name];
    % Path to actual images
    imageFolder = [dataFolder folderList(folderNum).name '\'];
    
    % If setInfo struct doesn't exist, create and save one.
    if isempty(dir([thisFolder '\setInfo.mat']))
        fprintf('setInfo.mat does not exist at \n%s\nMaking and saving one now.\n', thisFolder);
        setInfo = get_setInfo(thisFolder);
        save([thisFolder '\setInfo.mat'], 'setInfo')
    % If setInfo struct does exist, load it
    else
        load([thisFolder '\setInfo.mat']);
    end
	
	setN = 0;
	doneWithFolder = false;
	while ~doneWithFolder
		close all;
		setN = setN + 1;
		%thisSet = 
		% Load up image data from the set
		[X, r, c] = getImagesFromSetInfo(imageFolder, setInfo, setN);
		% Make sure X is an UINT8, for memory
		X = uint8(X);
		% Get number of images in this set
		[~, nIm] = size(X);
		for imN = 1:nIm
			% Define a function for reshaping data
			mat  = @(x) reshape(x(:,imN), r, c);
			% Display every image in a set
			figure;
			colormap('Gray');
			imagesc(mat(X));
			title(num2str(imN));
        end
        
        selectedImageNum = 1;
        while selectedImageNum > 0 
            % Prompt user for image number
            selectedImageNum = input('Type the image number you want.\n(Type "0" for none in this set and "-1" to stop with this folder)\n>> ');
            % If 0, skip the rest of this set
            if selectedImageNum == 0
                continue;
            % If -1, skip the rest of this folder
            elseif selectedImageNum < 0
                doneWithFolder = true;
            % Only allow integer responses
            elseif mod(selectedImageNum,1)
                warning('Invalid response. Skipping.')
            % User selected a valid image
            else
            
                % Create a unique saving name
                saveName = [];
                doneParsing = false;
                remain = folderList(folderNum).name;
                while ~doneParsing
                    % Get tokens, ignoring '\' for subdirectories
                    [tok, remain] = strtok(remain, '\');
                    % Append token to save name, replacing '\' with '_'
                    saveName = [saveName tok '_'];
                    % If done parsing, quit
                    if isempty(remain)
                        doneParsing = true;
                    end
                end
                    
                % Pull name from setInfo
                selectedImageName = setInfo(setN).names{selectedImageNum};
                % Try to copy it. If it doesn't work, display a warning
                if	~copyfile([imageFolder selectedImageName], [saveFolder saveName selectedImageName])
                    warning('Unable to copy image.');
                end
            end
        end
	end
	% If we've reached the end, quit
	if folderNum >= length(folderList)
		fprintf('Reached end of folder list.\n');
		done = true;
	end
end