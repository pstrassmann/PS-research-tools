% Written by Patrick Strassmann
% Find press-acceleration following stimulation

function [eventStackMatrix_output,eventTimesStack_output,postStimPressLats, postStimSeqDurations, shiftedBoutEndTimes, eventStackMatrix_output_wStimDur, eventStackTimes_output_wStimDur, shiftedBoutEndTimes_wStimDur] = postStimAccel(eventStackMatrix_stim,relStimTimesOn, relStimTimesOff, boutEndTimes, trialTimeLimit)


eventStackMatrix_output = zeros(size(eventStackMatrix_stim,1),trialTimeLimit);
eventStackMatrix_output_wStimDur = zeros(size(eventStackMatrix_stim,1),trialTimeLimit);

postStimPressLats = nan(1,size(eventStackMatrix_stim,1));
postStimSeqDurations = nan(1,size(eventStackMatrix_stim,1));

shiftedBoutEndTimes = nan(1,numel(boutEndTimes));
shiftedBoutEndTimes_wStimDur = nan(1,numel(boutEndTimes));


for i = 1:size(eventStackMatrix_stim,1)
    oneTrialEventMatrix = eventStackMatrix_stim(i,:);
    if isnan(relStimTimesOff(i))==0 && relStimTimesOff(i)>=0
        indOfFirstPressAfterStim = find(oneTrialEventMatrix(relStimTimesOff(i)+1:end)==1,1,'first') + numel(oneTrialEventMatrix(1:relStimTimesOff(i)));
        
        if isempty(indOfFirstPressAfterStim - relStimTimesOff(i))==0
            postStimPressLats(i) = indOfFirstPressAfterStim - relStimTimesOff(i); %********
            postStimSeqDurations(i) = boutEndTimes(i) - indOfFirstPressAfterStim; %********
        end
    end
    if isnan(relStimTimesOff(i))==0
        eventStackMatrix_output(i,1:numel(oneTrialEventMatrix(indOfFirstPressAfterStim:end))) = oneTrialEventMatrix(indOfFirstPressAfterStim:end);
    end
    if relStimTimesOn(i)~=0 && isnan(relStimTimesOn(i))==0 && relStimTimesOn(i)>=0
        eventStackMatrix_output_wStimDur(i,1:numel(oneTrialEventMatrix(relStimTimesOn(i):end))) = oneTrialEventMatrix(relStimTimesOn(i):end);
    end
    
    if ~isnan(relStimTimesOff(i)) || (exist('indOfFirstPressAfterStim','var') && ~isempty(indOfFirstPressAfterStim))
    shiftedBoutEndTimes(i) = boutEndTimes(i) - (numel(oneTrialEventMatrix)-numel(oneTrialEventMatrix(indOfFirstPressAfterStim:end)));
    end
    if isnan(relStimTimesOn(i))==0 && ~isnan(boutEndTimes(i)) && relStimTimesOn(i)>=0
        shiftedBoutEndTimes_wStimDur(i) = boutEndTimes(i) - (numel(oneTrialEventMatrix)-numel(oneTrialEventMatrix(relStimTimesOn(i):end)));
    end
end

%%% Find new bout end times %%

eventStackMatrix_output = trimStack(eventStackMatrix_output);
eventStackMatrix_output_wStimDur = trimStack(eventStackMatrix_output_wStimDur);
eventTimesStack_output = makeTimesStack(eventStackMatrix_output);
eventStackTimes_output_wStimDur = makeTimesStack(eventStackMatrix_output_wStimDur);
end