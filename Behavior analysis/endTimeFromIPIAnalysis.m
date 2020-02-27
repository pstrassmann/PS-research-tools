% Written by Patrick Strassmann
function [peakLoc,x,y] = endTimeFromIPIAnalysis(pressStackMatrix, slidingWindowSize,alpha, criterionOfPeakMax,boutEndTimes_optional)
if nargin<5
    boutEndTimes_optional = [];
        gaveBoutEnds = 0;
else
    boutEndTimes_optional = nanInvalidTrials(boutEndTimes_optional);
    invalidTrial_inds = isnan(boutEndTimes_optional);
    pressStackMatrix = pressStackMatrix(~invalidTrial_inds,:);
    boutEndTimes_optional = noNans(boutEndTimes_optional);
    gaveBoutEnds = 1;
end
if nargin<4
    criterionOfPeakMax = 0.99;
end
if nargin<2
    slidingWindowSize = 299;
    sigma = slidingWindowSize;
    alpha = slidingWindowSize/(2*sigma);
end

pressTimesStack = makeTimesStack(pressStackMatrix);
pressTimesStack(pressTimesStack==0)=nan;
IPIStack = diff(pressTimesStack')';
IPI_OccuranceTimeMatrix = nan(size(pressStackMatrix,1),size(pressStackMatrix,2));

for i = 1:size(IPI_OccuranceTimeMatrix,1);
currTrialPressTimes = pressTimesStack(i,:);
indOfFinalPress = find(~isnan(currTrialPressTimes),1,'last');
IPI_OccuranceTimeMatrix(i,pressTimesStack(i,1:indOfFinalPress-1))=IPIStack(i,1:indOfFinalPress-1);
end

IPISumPerBinVector = nansum(IPI_OccuranceTimeMatrix);
[x, y] = makeSmoothedPETH(IPISumPerBinVector,slidingWindowSize,alpha,0,1,1);
y = makeNorm(y);
peakLoc = markCriterionPeak(x,y,0,criterionOfPeakMax,1);

if gaveBoutEnds == 1
[sorted inds] = sort(boutEndTimes_optional);
sortedPressStackMatrix = pressStackMatrix(inds,:);
figure; plotRaster2(sortedPressStackMatrix,0,'k');
dottedVertLine(peakLoc/100,':',4);
dottedVertLine(mean(boutEndTimes_optional)/100,':',4,'r');
hold on; plot(x,y*numel(sorted),'linewidth',2);
end

end