%Written by Patrick Strassmann

function [means, sems] = tbtMeansAndErrorsFromStack(stack)
stack = trimStack(stack);
means = nan(1,size(stack,1));
sems = nan(1,size(stack,1));
for i = 1:size(stack,1)
    singleTrial = stack(i,:);
    singleTrial(singleTrial==0)=[];
    means(i) = mean(singleTrial);
    sems(i) = sem(singleTrial);
end
