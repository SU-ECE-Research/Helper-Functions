function done()
% Lets us know where we're done (audibly)
% Joshua Beard
% 2/1/17

load handel.mat;
y = y(1:floor(length(y)/4));
nBits = 8;
soundsc(y,Fs,nBits);