%Written by Patrick Strassmann

function [eventMatrixStack, eventTimesStack] = tossUnengagedTrials(eventMatrixStack, eventTimesStack)
    unengagedTrials = sum(eventTimesStack>0,2)<10;
    eventTimesStack(unengagedTrials,:)=[];
    eventMatrixStack(unengagedTrials,:)=[];
end