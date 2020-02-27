% Written by Patrick Strassmann

function [postStimBoutDurations] = findPostStimBoutDurations(stackMatrix, stimEndTime, boutEndTimes)
postStimBoutDurations = nan(1,numel(boutEndTimes));
stackTimes = makeTimesStack(stackMatrix);
for i = 1:size(stackTimes,1)
eventTimes_singleTrial = stackTimes(i,:);
timeOfFirstPressPostStim = eventTimes_singleTrial(find(eventTimes_singleTrial>stimEndTime,1,'first'));
if ~isempty(timeOfFirstPressPostStim)
postStimBoutDurations(i) = boutEndTimes(i)-timeOfFirstPressPostStim;
else
    postStimBoutDurations(i) = 0;
end
end



end

