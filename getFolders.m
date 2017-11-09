function [ folderList, numFolders, emptyFolders] = getFolders()
%getFolders Creates a list of folder names that have camera images to process
% Edited by Joshua Beard 4/1/17
% Returns cell array of empty folders if any exist
% Global variable with folder name for input images from one year. 
global inputMainFolderName;

% Find out the names of all of the folders
folderList = dir(inputMainFolderName);
numEmptyFolders = 0;
emptyFolders = {};
% Remove the usual listing of "." and ".." folders
while folderList(1).name(1) == '.'
    folderList(1) = [];
end
numFolders = length(folderList); % number of folders in the directory

% Check if there are subfolders and add them to the list. Note that any new
% subfolder is added to the end of the folderList variable and numFolders
% is increased by 1. Therefore, the algorithm will also look inside this
% new folder to see if there is another folder in there.
i = 1;
while i <= numFolders   % for all folders
    if folderList(i).isdir
        fprintf('Processing folder %i out of %i (%s)\n', i, numFolders, folderList(i).name);
        % get the name of the folder
        folderMain = folderList(i).name;
        % check the folder content
        listing = dir([inputMainFolderName folderMain '\']);
      
        try % For handling empty folders
            % Remove the usual listing of "." and ".." folders
            while listing(1).name(1) == '.'
                listing(1) = [];
            end
        catch
            warning(['Folder number ' num2str(i) ' (' folderList(i).name ') has no files. Skipping.']);
            numEmptyFolders = numEmptyFolders + 1;
            emptyFolders{numEmptyFolders} = folderList(i).name;
            i = i+1;
            continue;
        end
        
        % check if there are JPEG files
        fileNames = dir([inputMainFolderName folderMain '\*.JPG']);
        
        % If there are subfolders in this folder
        if length(listing) ~= length(fileNames)
            for j = 1 : length(listing)
                if listing(j).isdir
                    listing(j).name = [folderMain '\' listing(j).name];
                    folderList(length(folderList)+1) = listing(j);
                    fprintf('Adding folder %s\n', listing(j).name);
                    numFolders = numFolders + 1;
                end
            end
        end
    end
i = i + 1;
end

% Remove folder names from the listing if there are no images in them. 
% Note that this only removes the parent folder name. If the folder has
% subfolders, they will be listed separately and their listings are not
% deleted.
imagesExist = [];
for i = 1 : numFolders
    % get the name of the folder
    folderMain = folderList(i).name;
    % check if there are JPEG files
    if length(dir([inputMainFolderName folderMain '\*.JPG']))
        imagesExist(i) = 1;
    end
end

i = find(imagesExist == 0);
folderList(i) = [];
numFolders = length(folderList);



end

