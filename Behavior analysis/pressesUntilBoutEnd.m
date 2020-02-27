% Written by Patrick Strassmann
function [pressSumTillBoutEndMat] = pressesUntilBoutEnd(pressStackMatrix, boutEndTimes, boutStartTimes)

if nargin<3
    boutStartTimes = ones(1,numel(boutEndTimes));
end

    noNansPressStackMatrix = pressStackMatrix;
    if ~size(noNansPressStackMatrix,1)<boutEndTimes
    noNansPressStackMatrix(isnan(boutEndTimes),:) = [];
    end
    pressSumTillBoutEndMat = zeros(1,size(noNansPressStackMatrix,1));
    noNansBoutEndTimes = noNans(boutEndTimes);
    noNansBoutStartTimes = noNans(boutStartTimes);
    for i = 1:size(noNansPressStackMatrix,1)
        pressSumTillBoutEndMat(i) = sum(pressStackMatrix(i,noNansBoutStartTimes(i):noNansBoutEndTimes(i)));
    end 

end

