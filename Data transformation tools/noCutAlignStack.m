%Written by Patrick Strassmann

function [stackedPressMatrices_boutAligned_noCut, corrShiftVal_noCut] = noCutAlignStack(eventMatrixStack, boutStartTimes,trialTimeLimit)

maxBoutStartTime = max(boutStartTimes);
meanBoutStartLatency = mean(noNans(boutStartTimes));
if ~isnan(meanBoutStartLatency)
singleTrialNumInds = trialTimeLimit + maxBoutStartTime;
stackedPressMatrices_boutAligned_noCut = zeros(size(eventMatrixStack,1),singleTrialNumInds);
for i = 1:size(eventMatrixStack,1)
    if ~isnan(boutStartTimes(i))
        stackedPressMatrices_boutAligned_noCut(i,1:trialTimeLimit+maxBoutStartTime-boutStartTimes(i)) = [zeros(1,maxBoutStartTime-boutStartTimes(i)) eventMatrixStack(i,:)];
    else
        stackedPressMatrices_boutAligned_noCut(i,:)=zeros(1,singleTrialNumInds);
    end
end
[rows, cols] = find(stackedPressMatrices_boutAligned_noCut==1);
minCol = min(cols);
stackedPressMatrices_boutAligned_noCut = stackedPressMatrices_boutAligned_noCut(:,minCol:trialTimeLimit+minCol-1);
corrShiftVal_noCut = meanBoutStartLatency+minCol-1-maxBoutStartTime;
else
    stackedPressMatrices_boutAligned_noCut = nan;
    corrShiftVal_noCut = nan;
end

