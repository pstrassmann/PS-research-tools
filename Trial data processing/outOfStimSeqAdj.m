%Written by Patrick Strassmann

function [ stackTimes_adj ] = outOfStimSeqAdj(stackTimes,leverPressTimes,switchPointTimes)

stackTimes_adj = [stackTimes (nan(size(stackTimes,1),20))];
for i = 1:size(stackTimes,1)
    isolatedRow = stackTimes(i,:);
    lastPressTime_ind = find(~isnan(isolatedRow),1,'last');
    lastPressTimes = isolatedRow(lastPressTime_ind);
  
    if isempty(lastPressTimes)
        continue
    end
    if ~any(switchPointTimes(:) == lastPressTimes);
        nextSwitchPoint = switchPointTimes(find(switchPointTimes>lastPressTimes,1,'first'));
        restOfSequence = leverPressTimes((lastPressTimes<leverPressTimes & leverPressTimes<=nextSwitchPoint));
    else
        continue
    end
    
 newRow = [isolatedRow(1:lastPressTime_ind) restOfSequence];
 stackTimes_adj(i,1:numel(newRow)) = newRow;
    
end
stackTimes_adj = trimStack_nan(stackTimes_adj);



end

