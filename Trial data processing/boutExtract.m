function [boutStartTimes, boutEndTimes, boutDurations, stackedBoutMatrices, stackedBoutTimes, stackedBoutIPIs, stackedBoutTimes_aligned, meanBoutStartLatency stackedPressMatrices_boutAligned_noCut corrShiftVal_noCut]...
    = boutExtract(eventMatrixStack,...
    eventTimesStack,...
    trialTimeLimit,...
    consecPresses,...
    criterionIPI_start,...
    criterionIPI_end,...
    medianFactor,...
    relStimTimesOff,...
    relStimTimesOn,...
    limitBoutStartToEndOfStim)
if nargin<10
    limitBoutStartToEndOfStim = 0;
end

if nargin<8
    relStimTimesOff = [];
    relStimTimesOn = [];
end

defaultVectorLength = 1000;
cutOff = 10000; %only look for IPIs up to this cutOff
boutStartTimes = nan(1,size(eventTimesStack,1));
boutEndTimes = nan(1,size(eventTimesStack,1));
boutDurations = nan(1,size(eventTimesStack,1));
stackedBoutMatrices = zeros(size(eventTimesStack,1),trialTimeLimit);
stackedBoutTimes = zeros(size(eventTimesStack,1),defaultVectorLength);
stackedBoutIPIs = zeros(size(eventTimesStack,1), defaultVectorLength);

for i=1:size(eventTimesStack,1)
    oneTrialEventTimes = eventTimesStack(i,1:find(eventTimesStack(i,:)>0,1,'last'));
    %TEST 3-30-16*******************************************************
    firstEventTimeAfterCutOff = oneTrialEventTimes(find(oneTrialEventTimes>cutOff,1,'first'));
    oneTrialEventTimes(oneTrialEventTimes>cutOff)=[];
    if ~isempty(firstEventTimeAfterCutOff)
        oneTrialEventTimes = [oneTrialEventTimes firstEventTimeAfterCutOff];
    else
        oneTrialEventTimes = [oneTrialEventTimes trialTimeLimit];
    end
    medianFactor=1; %display('~~~Median Factor not being used, default set to 1~~~')
    %END TEST***********************************************************
    oneTrialEventIPIs = diff(oneTrialEventTimes);
    oneTrialEventIPIsWithEndZero = oneTrialEventIPIs; %diff(horzcat(oneTrialEventTimes,trialTimeLimit)); %performed a few lines up
    
    if isempty(relStimTimesOff) ==1%
        greaterThanMedianEventTimes = oneTrialEventTimes(oneTrialEventTimes>(median(oneTrialEventTimes)*medianFactor));
    else
        %greaterThanMedianEventTimes = oneTrialEventTimes(oneTrialEventTimes>(median(oneTrialEventTimes)*medianFactor));
        greaterThanMedianEventTimes = oneTrialEventTimes(oneTrialEventTimes>(median(oneTrialEventTimes)*medianFactor) & oneTrialEventTimes>relStimTimesOff(i));
    end
    
    greaterThanCriterionIPI = oneTrialEventTimes(oneTrialEventIPIsWithEndZero >= criterionIPI_end);
    
    if isempty(greaterThanMedianEventTimes)==0 && isempty(greaterThanCriterionIPI)==0
        boutEndTime = min(intersect(greaterThanMedianEventTimes,greaterThanCriterionIPI));
        
    elseif isempty(oneTrialEventTimes)==1
        boutEndTime = nan;
    else
        boutEndTime  = nan; %boutEndTime = oneTrialEventTimes(end);
    end
    
    if (isempty(boutEndTime)==1)
        boutEndTime  = nan; %boutEndTime = oneTrialEventTimes(end);
    end
    
    lessThanCriterionIPI = oneTrialEventIPIs<criterionIPI_start;
    
    boutStartTimeSet = 0;
    if limitBoutStartToEndOfStim == 1
        if isempty(relStimTimesOff)==0 %&& numel(unique(relStimTimesOff))==1 % If stimulating during latency period, count first press after end of stim as start of bout
            %             boutStartTime = oneTrialEventTimes(find(oneTrialEventTimes>relStimTimesOff(i)==1,1,'first'));  % LIMITS BOUT START FINDING TO AFTER STIMULATION
            %             boutStartTimeSet = 1;
            oneTrialEventTimes = oneTrialEventTimes(oneTrialEventTimes>relStimTimesOff(i));  % LIMITS BOUT START FINDING TO AFTER STIMULATION
            oneTrialEventIPIs = diff(oneTrialEventTimes);
            lessThanCriterionIPI = oneTrialEventIPIs<criterionIPI_start;
            for j = 1:numel(lessThanCriterionIPI)-consecPresses
                if isequal(lessThanCriterionIPI(j:j+consecPresses-2),ones(1,consecPresses-1))==1;
                    boutStartTime = oneTrialEventTimes(j);
                    boutStartTimeSet = 1;
                    break
                end
            end
        else
            if isempty(relStimTimesOn)==0 && isequal(eventTimesStack(:,1)',relStimTimesOn)==1
                oneTrialEventTimes = oneTrialEventTimes(oneTrialEventTimes>relStimTimesOff(i)); % LIMITS BOUT START FINDING TO AFTER STIMULATION
                oneTrialEventIPIs = diff(oneTrialEventTimes);
                lessThanCriterionIPI = oneTrialEventIPIs<criterionIPI_start;
            end
            for j = 1:numel(lessThanCriterionIPI)-consecPresses
                if isequal(lessThanCriterionIPI(j:j+consecPresses-2),ones(1,consecPresses-1))==1;
                    boutStartTime = oneTrialEventTimes(j);
                    boutStartTimeSet = 1;
                    break
                end
            end
        end
    else
        if isempty(relStimTimesOn)==0 && isequal(eventTimesStack(:,1)',relStimTimesOn)==1
            oneTrialEventIPIs = diff(oneTrialEventTimes);
            lessThanCriterionIPI = oneTrialEventIPIs<criterionIPI_start;
        end
        for j = 1:numel(lessThanCriterionIPI)-consecPresses
            if isequal(lessThanCriterionIPI(j:j+consecPresses-2),ones(1,consecPresses-1))==1;
                boutStartTime = oneTrialEventTimes(j);
                boutStartTimeSet = 1;
                break
            end
        end
    end
    
    
    if boutStartTimeSet ==0, boutStartTime=nan; end
    if isempty(boutStartTime); boutStartTime = nan; end
    
    % Remove this section to include incomplete bout bounderies in dataset.
    if isnan(boutStartTime)==1 || isnan(boutEndTime)==1
        boutStartTime = nan;
        boutEndTime = nan;
    end
    %**********
    
    boutStartTimes(boutStartTimes==0)=1;  %If any boutStartTimes = 0, change them to 1
    boutStartTimes(i)= boutStartTime;
    boutEndTimes(i) = boutEndTime;
    
    if isnan(boutEndTime)==0 & isnan(boutStartTime)==0 & boutEndTime>boutStartTime % & (boutEndTime-boutStartTime)>
        if boutStartTime == 0, boutStartTime = 1; end
        boutDurations(i) = boutEndTime-boutStartTime;
        oneTrialBoutEventMatrix = eventMatrixStack(i,boutStartTime:boutEndTime);
        oneTrialBoutEventMatrix_padded = horzcat(oneTrialBoutEventMatrix,zeros(1,trialTimeLimit-numel(oneTrialBoutEventMatrix)));
        oneTrialBoutEventTimes = find(oneTrialBoutEventMatrix==1);
        oneTrialBoutEventTimes_padded = horzcat(oneTrialBoutEventTimes,zeros(1,defaultVectorLength-numel(oneTrialBoutEventTimes)));
        stackedBoutMatrices(i,:) = oneTrialBoutEventMatrix_padded;
        stackedBoutTimes(i,:) = oneTrialBoutEventTimes_padded;
        oneTrialBoutIPIs = diff(oneTrialBoutEventTimes);
        stackedBoutIPIs(i,:) =  [oneTrialBoutIPIs zeros(1,defaultVectorLength-numel(oneTrialBoutIPIs))];
    end
end

boutStartTimes(isnan(boutDurations))= nan;
boutEndTimes(isnan(boutDurations)) = nan;
stackedBoutMatrices(~any(stackedBoutMatrices,2),:)=[];
stackedBoutTimes(~any(stackedBoutTimes,2),:)=[];
% stackedBoutIPIs(~any(stackedBoutIPIs,2),:)=[];

if isempty(stackedBoutTimes)==0
    stackedBoutTimes_aligned = stackedBoutTimes - repmat(stackedBoutTimes(:,1),1,size(stackedBoutTimes,2));
    stackedBoutTimes_aligned(stackedBoutTimes_aligned<0)=0;
    stackedBoutTimes_aligned(:,1)=1;
    noNansBoutStartTimes = boutStartTimes(~isnan(boutStartTimes));
    meanBoutStartLatency = mean(noNansBoutStartTimes);
else
    stackedBoutTimes_aligned = [];
    meanBoutStartLatency = [];
end

% if isempty(stackedBoutTimes)==0
% meanBoutEndTime = round(nanmean(boutEndTimes));
% boutEndAdjustments = boutStartTimes+(meanBoutEndTime-boutEndTimes);
% stackedBoutTimes_EndAligned = stackedBoutTimes+repmat(noNans(boutEndAdjustments)',1,size(stackedBoutTimes,2));
% maxPTime = max(max(stackedBoutTimes_EndAligned));
% emptyMat = zeros(size(stackedBoutTimes_EndAligned,1),maxPTime);
% for row = 1:size(stackedBoutTimes_EndAligned,1)
%     emptyMat(row,stackedBoutTimes_EndAligned(row,:))=1;
% end
% end

%~~~~~~~~~~ /Commented out 3-03-16~~ Turn on for noCutAlignStack
% [stackedPressMatrices_boutAligned_noCut, corrShiftVal_noCut] = noCutAlignStack(eventMatrixStack, boutStartTimes, trialTimeLimit);
stackedPressMatrices_boutAligned_noCut = [];
corrShiftVal_noCut = [];
%~~~~~~~~~~

% maxBoutStartTime = max(boutStartTimes);
% singleTrialNumInds = trialTimeLimit + maxBoutStartTime;
% stackedPressMatrices_boutAligned_noCut = zeros(size(eventMatrixStack,1),singleTrialNumInds);
% for i = 1:size(eventMatrixStack,1)
%     if ~isnan(boutStartTimes(i))
%         stackedPressMatrices_boutAligned_noCut(i,1:trialTimeLimit+maxBoutStartTime-boutStartTimes(i)) = [zeros(1,maxBoutStartTime-boutStartTimes(i)) eventMatrixStack(i,:)];
%     else
%         stackedPressMatrices_boutAligned_noCut(i,:)=zeros(1,singleTrialNumInds);
%     end
% end
% [rows, cols] = find(stackedPressMatrices_boutAligned_noCut==1);
% minCol = min(cols);
% stackedPressMatrices_boutAligned_noCut = stackedPressMatrices_boutAligned_noCut(:,minCol:trialTimeLimit+minCol-1);
% corrShiftVal_noCut = meanBoutStartLatency+minCol-1-maxBoutStartTime;
end