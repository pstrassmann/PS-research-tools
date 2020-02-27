% Written by Patrick Strassmann
function [pctChangeElementByElement, rawChange] = pctChangeElementByElement(noStimMat, stimMat)

if isequal(size(stimMat,2),size(noStimMat,2)+1) %if the second matrix has one more column than the noStim matrix, assumes that the initial column is noStim data
    stimMat = stimMat(:,2:end);
end
rawChange = stimMat-noStimMat;
pctChangeElementByElement = (rawChange./noStimMat)*100;
end

