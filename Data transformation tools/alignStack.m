%Written by Patrick Strassmann

function [alignedStack] = alignStack(stackedBoutTimes)
    alignedStack = stackedBoutTimes - repmat(stackedBoutTimes(:,1),1,size(stackedBoutTimes,2));
    alignedStack(alignedStack<0)=0;
end