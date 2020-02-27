% Written by Patrick Strassmann
function [ nanTrimmedMat, ultMinXshift] = dblNanTrim(mat, trialTimeLimit)
    startInd = find(all(isnan(mat))==0,1,'first');
    stopInd = find(all(isnan(mat))==0,1,'last');
    nanTrimmedMat = mat(:,startInd:stopInd);
    nanTrimmedMat(isnan(nanTrimmedMat))=0;
    ultMinXshift = trialTimeLimit-startInd;
end

