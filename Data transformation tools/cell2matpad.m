% Written by Patrick Strassmann
function [ mat ] = cell2matpad(inputCell)
numElements = cellfun(@numel,inputCell);
maxNumEl = max(numElements);

mat = nan(numel(inputCell),maxNumEl);
for i = 1:numel(inputCell)
    currPETH = inputCell{i};
    mat(i,1:numel(currPETH))=currPETH;
end
end

