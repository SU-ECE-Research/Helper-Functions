function newPath = pathJoin(varargin)
% Joins all parts into a single valid path string regardless of whether any
% of them have directory separators or not. Will perform fastest if there
% are no separators on the fronts or backs of any of the parts (except for
% the front of the first string and back of the last string)
% Joshua Beard
% 4/11/17

newPath = varargin{1};
for q = 2:length(varargin)
    % First part doesn't end with \ and second part doesn't start with \
    if ~strcmp(newPath(end),'\') && ~strcmp(varargin{q}(1), '\')
        newPath = [newPath '\' varargin{q}];
        
    % First part ends with \ and second part doesn't start with \
    elseif strcmp(newPath(end),'\') && ~strcmp(varargin{q}(1), '\')
        newPath = [newPath varargin{q}];
        
    % First part doesn't end with \ and second part starts with \
    elseif ~strcmp(newPath(end),'\') && strcmp(varargin{q}(1), '\')
        newPath = [newPath varargin{q}];
        
    % First part ends with \ and second part starts with \
    else
        newPath = [newPath(1:end-1) varargin{q}];
    end
end