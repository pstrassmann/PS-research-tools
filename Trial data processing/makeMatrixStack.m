% Written by Patrick Strassmann
function [ eventMatrixStack ] = makeMatrixStack(timesStack)
    timesStack = uint64(timesStack);
    maxTime = max(max(timesStack));
    eventMatrixStack = zeros(size(timesStack,1),maxTime);

for i = 1:size(timesStack,1)
    singleVect = trimStack(timesStack(i,:));
    if singleVect(1) == 0
        singleVect(1)=[];
    end
    eventMatrixStack(i,singleVect)=1;
end

