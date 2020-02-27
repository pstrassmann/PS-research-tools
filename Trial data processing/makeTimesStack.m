% Written by Patrick Strassmann
function [ eventStackTimes ] = makeTimesStack(matStack,maxNumEvents)
if nargin<2
maxNumEvents = max(sum(matStack,2)); %finds max number of events per trial
end
eventStackTimes = zeros(size(matStack,1),maxNumEvents);
for i = 1:size(matStack,1)
    oneTrialTimes = find(matStack(i,:)==1);
    eventStackTimes(i,1:numel(oneTrialTimes)) = oneTrialTimes;
end