%Written by Patrick Strassmann

function [ normMat ] = normByRowMax(inputMatrix)
% Given a numerical matrix input, this function returns a matrix
% where each row has been normalized to its largest value.

rowMax = max(inputMatrix,[],2);
normMat = inputMatrix ./ repmat(rowMax,1,size(inputMatrix,2));

end

