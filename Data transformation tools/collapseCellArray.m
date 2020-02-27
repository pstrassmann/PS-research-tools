% Written by Patrick Strassmann
function [ collapsed_cell ] = collapseCellArray(inputCell, collapseMat)
%collapseCellArray: given an m x n matrix, merges columns of data so that
%only m cells remain
collapsed_cell = cell(size(inputCell,1),1);
for i = 1:size(inputCell,1)
    workingMat = [];
    for j = 1:numel(collapseMat)
        workingMat = [workingMat inputCell{i,collapseMat(j)}];
    end
    collapsed_cell{i} = workingMat;
end

