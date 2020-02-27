%Written by Patrick Strassmann

function [trimmedMatrix] = trimStack(stack)
% Trims excess zeros from end of matrix
if ~isempty(stack) && ~isequal(stack(:,end),zeros(size(stack,1),1))
    trimmedMatrix = stack;
elseif size(stack,1)>1
    lastDataPointInd = find(nansum(stack)>0, 1, 'last');
    trimmedMatrix = stack(:,1:lastDataPointInd);
elseif size(stack,1)==1
    lastDataPointInd = find(stack>0,1,'last');
    trimmedMatrix = stack(1:lastDataPointInd);
else
    trimmedMatrix = [];
end
end