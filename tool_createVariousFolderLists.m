% Tool for creating folder lists for SVM training, testing, spot detection,
% and unassigned folders
%{
Joshua Beard
C: 1/21/17
E: 1/21/17
%}

dataFolder = '\\ecefs1\ECE_Research-Space-Share\DATA\Tajikistan_2012_CTPhotos\Murghab_Concession\';
resultsFolder = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Murghab_Concession\';
load([resultsFolder 'folderList']);

svmIndices = [
    ];
testIndices = [
    ];
spotIndices = [
    ];
unassignedIndices = [
    ];
unusableIndices = [];
%%
for q = 1:length(folderList)
    fprintf('Index %d\n Folder %s\n', q, folderList(q).name)
    i = input(['\n0,1,2,3: unassigned, spots, svm, test >>']);
    switch i
        case 0
            unassignedIndices = [unassignedIndices; q];
        case 1
            spotIndices = [spotIndices; q];
        case 2
            svmIndices = [svmIndices; q];
        case 3
            testIndices = [testIndices; q];
        case 5
            unusableIndices = [unusableIndices; q];
    end
end

%%
folderListDup = folderList;
for q = 1:length(unassignedIndices)
    unassignedFolderList(q) = folderList(unassignedIndices(q));
    folderListDup(unassignedIndices(q)).name = [];
end
%%
for q = 1:length(spotIndices)
    spotFolderList(q) = folderList(spotIndices(q));
    folderListDup(spotIndices(q)).name = [];
end
%%
for q = 1:length(svmIndices)
    svmFolderList(q) = folderList(svmIndices(q));
    folderListDup(svmIndices(q)).name = [];
end
%%
for q = 1:length(testIndices)
    testFolderList(q) = folderList(testIndices(q));
    folderListDup(testIndices(q)).name = [];
end
for q = 1:length(unusableIndices)
    unusableFolderList(q) = folderList(unusableIndices(q));
    folderListDup(unusableIndices(q)).name = [];
end

%%
if ~isempty(unassignedIndices)
    save([resultsFolder 'unassignedFolderList.mat'], 'unassignedFolderList');
end
if ~isempty(unusableIndices)
    save([resultsFolder 'unusableFolderList.mat'], 'unusableFolderList');
end
if ~isempty(spotIndices)
    save([resultsFolder 'spotFolderList.mat'],'spotFolderList');
end
if ~isempty(svmIndices)
    save([resultsFolder 'svmFolderList.mat'],'svmFolderList');
end
if ~isempty(testIndices)
    save([resultsFolder 'testFolderList.mat'],'testFolderList');
end