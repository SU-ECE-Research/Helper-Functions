function lastToken = getLastToken(str, delim)
% gets last token of a string
[T, R] = strtok(str, delim);

while ~isempty(T)
    lastToken = T;
    [T, R] = strtok(R, delim);
end

