function same = sameCam(fullName, camID)
% HARDCODED
% Returns 1 if the camID is in the fullName, 0 if not
%{
Joshua Beard
C: 2/4/17
E: 2/4/17
%}

bPref = camID(1:5);
if length(camID) > 10
    bNum = camID(7:14);                     % Cam is C
else
    bNum = camID(7:end);                    % Cam is P
end

if strcmp(fullName(66),'u')                 % Image is ATO
    if strcmp(bPref, fullName(84:88))                 % Cam is ATO
        if strcmp(fullName(90:92), 'CAM')
            if strcmp(fullName(90:97), bNum)
                same = true;
            else
                same = false;
            end
        else
            if strcmp(fullName(90:93), bNum)    % image and cam are same
                same = true;
            else    % Image and cam are both ATO, different numbers
                same = false;                           
            end 
        end
    else        % Image is ATO, cam is MAD
        same = false;       
    end
else                                        % image is MAD
    if strcmp(bPref, fullName(80:84))                 % cam is MAD 
        if strcmp(fullName(86:88), 'CAM')
            if strcmp(fullName(86:93), bNum)
                same = true;
            else
                same = false;
            end
        else
            if strcmp(fullName(86:89), bNum)    % image and cam are same   
                same = true;
            else    % Image and cam are both MAD, different numbers
                same = false;
            end
        end
    else        % Image is MAD, cam is ATO
        same = false;                       
    end
end
%\\ecefs1\ECE_Research-Space-Share\RESS\Tajikistan_2012_CTPhotos\Murghab_Concession\MAD04\CAM00000
%\\ecefs1\ECE_Research-Space-Share\RULS\Tajikistan_2012_CTPhotos\Madiyan_Pshart\MAD04\CAM00000