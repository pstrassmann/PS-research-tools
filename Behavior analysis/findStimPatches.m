% Written by Patrick Strassmann

function [stimMatrixOn, stimMatrixOff,stimMatrixDur] =  findStimPatches(trialStartTimes, trialEndTimes,stimTimesOn, stimTimesOff, boutStartTimes, wantPatchPlot)

if nargin<6
    wantPatchPlot=1;
end

if nargin<5 || isempty(boutStartTimes)==1
    boutStartTimes = zeros(1,numel(trialStartTimes));
    meanBoutStartLatency = 0;
else

    meanBoutStartLatency = mean(boutStartTimes(~isnan(boutStartTimes)));
end

stimMatrixOn = nan(size(trialStartTimes,2),2000);
stimMatrixOff = nan(size(trialStartTimes,2),2000);
yIndInPlot = 0;
for i = 1:numel(trialStartTimes)
    if isnan(boutStartTimes(i))==1
       continue 
    end
    yIndInPlot = yIndInPlot+1;
    trialStimInds_off = (stimTimesOff>trialStartTimes(i) & stimTimesOff<=trialEndTimes(i));
    oneTrialStimTimesOff = stimTimesOff(trialStimInds_off)-trialStartTimes(i);
    
    trialStimInds_on = (stimTimesOn>trialStartTimes(i) & stimTimesOn<trialEndTimes(i));
    oneTrialStimTimesOn = stimTimesOn(trialStimInds_on)-trialStartTimes(i);
    oneTrialStimTimesOn_pruned = zeros(1,numel(oneTrialStimTimesOff));
    q=1;
    for j = 1:numel(oneTrialStimTimesOff)
       try  oneTrialStimTimesOn_pruned(j) = oneTrialStimTimesOn(q); end
        q = find(oneTrialStimTimesOn<oneTrialStimTimesOff(j),1,'last')+1;
    end

    stimMatrixOn(i,1:numel(oneTrialStimTimesOn_pruned)) = oneTrialStimTimesOn_pruned;
    stimMatrixOff(i,1:numel(oneTrialStimTimesOff)) = oneTrialStimTimesOff;
    if wantPatchPlot==1
    for j = 1:numel(oneTrialStimTimesOff)
        p=patch([oneTrialStimTimesOn_pruned(j)-boutStartTimes(i)+meanBoutStartLatency oneTrialStimTimesOff(j)-boutStartTimes(i)+meanBoutStartLatency oneTrialStimTimesOff(j)-boutStartTimes(i)+meanBoutStartLatency oneTrialStimTimesOn_pruned(j)-boutStartTimes(i)+meanBoutStartLatency]*10/1000, [yIndInPlot-.3 yIndInPlot-.3 yIndInPlot+.3 yIndInPlot+.3],rgb('cyan'));
        set(p,'FaceAlpha',0.5','edgecolor',rgb('cyan'),'edgealpha',0.5); hold on;
    end
    end
end

stimMatrixOn = trimStack(stimMatrixOn);
stimMatrixOff = trimStack(stimMatrixOff);
stimMatrixDur = stimMatrixOff-stimMatrixOn;