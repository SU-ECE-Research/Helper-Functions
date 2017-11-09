function numDelFiles = deleteFileType(folder, fileType)
% deletes all files in a specified folder of a specified type

% TBH and JB 
% C: 1/29/17
% E: 1/29/17

if ~strcmp(folder(end),'\') % Append '\' if not there
    folder = [folder '\'];
end

thisDir = dir([folder '*.' fileType]);
numDelFiles = 0;

%%
% only do if thisDir isn't empty
if ~isempty(thisDir)
    for q = 1:length(thisDir)
        delete([folder thisDir(q).name]);
        numDelFiles = numDelFiles+1;
    end
end