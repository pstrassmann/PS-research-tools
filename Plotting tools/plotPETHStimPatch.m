% Written by Patrick Strassmann
function [] = plotPETHStimPatch(relStimTimesOn, relStimTimesOff, boutStartTimes, meanStartLatency)%%%%
if nargin<4
    meanStartLatency = 0;
end
nonNanInds = ~isnan(boutStartTimes);
boutStartTimes = boutStartTimes(nonNanInds);
relStimTimesOn = relStimTimesOn(nonNanInds);
relStimTimesOff = relStimTimesOff(nonNanInds);

    if (sum(relStimTimesOn-boutStartTimes)>=0 && ~isequal(meanStartLatency,0)) || (all((relStimTimesOn-boutStartTimes)<0) && meanStartLatency==0)
        ylimit = ylim();
        if isequal(meanStartLatency,0)
            startX = relStimTimesOn(1);
            stopX = relStimTimesOff(1);
        else
            startX = meanStartLatency+relStimTimesOn(1)-boutStartTimes(1);
            stopX = meanStartLatency+relStimTimesOff(1)-boutStartTimes(1);
        end
    end
end