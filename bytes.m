function B = bytes(var)
% Returns number of bytes the variable takes up in memory
%{
Joshua Beard
C: 1/27/17
E: 1/27/17
%}
B = whos('var');
B = B.bytes;
end