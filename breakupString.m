function tokens = breakupString(str, delim)
% Breaks apart a string according to the delimiter
% Joshua Beard 3/27/17

nTok = 0;
while ~isempty(str)
    nTok = nTok+1;
    [tokens{nTok}, str] = strtok(str, delim);
end