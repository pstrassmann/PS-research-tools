% Written by Patrick Strassmann
function [probeCategVect, rewardCategVect, probeStmCategVect, rewardStmCategVect] =  findPrecededTrialCateg(startTime, endTime, eventStartTimes_probe, eventStartTimes_rwd, eventStartTimes_probeStm, eventStartTimes_rwdStm)

if nargin<5
    eventStartTimes_rwdStm = [];
    eventStartTimes_probeStm = [];
end

timeBins = str2double(endTime)-str2double(startTime); 
timeBinsVect = zeros(1,timeBins);
timeBinsVect(eventStartTimes_probe)=2; 
timeBinsVect(eventStartTimes_rwd)=1;

timeBinsVect(eventStartTimes_probeStm)=4;
timeBinsVect(eventStartTimes_rwdStm)=3;

timeBinsVect(timeBinsVect==0) = [];
rewardInds = find(timeBinsVect==1);
probeInds = find(timeBinsVect==2);
rewardStmInds = find(timeBinsVect==3);
probeStmInds = find(timeBinsVect==4);

rewardCategVect = zeros(1,numel(eventStartTimes_rwd));
probeCategVect = zeros(1,numel(eventStartTimes_probe));
rewardStmCategVect = zeros(1,numel(eventStartTimes_rwdStm));
probeStmCategVect = zeros(1,numel(eventStartTimes_probeStm));

for i = 1:numel(rewardInds)
    currInd = rewardInds(i);
    if currInd == 1
        continue
    elseif timeBinsVect(currInd-1)==1 | timeBinsVect(currInd-1)==3
        rewardCategVect(i)=1;
    elseif timeBinsVect(currInd-1)==2 | timeBinsVect(currInd-1)==4
        rewardCategVect(i)=2;  
    end  
end

for i = 1:numel(probeInds)
    currInd = probeInds(i);
    if currInd == 1
        continue
    elseif timeBinsVect(currInd-1)==1 | timeBinsVect(currInd-1)==3
        probeCategVect(i)=1;
    elseif timeBinsVect(currInd-1)==2 | timeBinsVect(currInd-1)==4
        probeCategVect(i)=2;  
    end
end

for i = 1:numel(rewardStmInds)
    currInd = rewardStmInds(i);
    if currInd == 1
        continue
    elseif timeBinsVect(currInd-1)==1 | timeBinsVect(currInd-1)==3
        rewardStmCategVect(i)=1;
    elseif timeBinsVect(currInd-1)==2 | timeBinsVect(currInd-1)==4
        rewardStmCategVect(i)=2;  
    end  
end

for i = 1:numel(probeStmInds)
    currInd = probeStmInds(i);
    if currInd == 1
        continue
    elseif timeBinsVect(currInd-1)==1 | timeBinsVect(currInd-1)==3
        probeStmCategVect(i)=1;
    elseif timeBinsVect(currInd-1)==2 | timeBinsVect(currInd-1)==4
        probeStmCategVect(i)=2;  
    end
end