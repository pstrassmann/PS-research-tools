%Written by Patrick Strassmann
function [corrXvaluesForPETH, smoothedPETH] = makeSmoothedPETH(eventMatrixStack, slidingWindowSize, alpha, forAlignedYesNo,tossUnengagedTrials,doubleSmooth, doubleSmoothWindow,trimStackYN)

if nargin<8
    trimStackYN = 1;
end

if nargin<7
    doubleSmoothWindow = 299;
end

if nargin<6
    doubleSmooth = 0;
end

if nargin<5
    tossUnengagedTrials = 0;
end

if tossUnengagedTrials==1
    unengagedTrials = sum(eventMatrixStack,2)<10;
    eventMatrixStack(unengagedTrials,:)=[];
end

if trimStackYN==1
    
    eventMatrixStack = trimStack(eventMatrixStack);
end
if size(eventMatrixStack,1)>1
    meanEventVector = nanmean(eventMatrixStack);
elseif size(eventMatrixStack,1)==1
    meanEventVector = eventMatrixStack;
else meanEventVector = [];
end
if forAlignedYesNo==1
    alignedInd = find(sum(eventMatrixStack)==size(eventMatrixStack,1),1,'first');
    meanEventVector(alignedInd)=0;
end
if ~isempty(meanEventVector)
    slidingWindowStartMean = mean(meanEventVector(1:round(slidingWindowSize/2)));
    slidingWindowStopMean = mean(meanEventVector(end-round(slidingWindowSize/2):end));
    
    %Using the mean of the press rate in the sliding window to pad edges of
    %meanEventVector so that 'same' convolution does not result in drops in
    %press rate due to padding with zeros
    meanEventVector_orig = meanEventVector;
    meanEventVector = [ones(1,fix(slidingWindowSize/2))*slidingWindowStartMean meanEventVector ones(1,fix(slidingWindowSize/2))*slidingWindowStopMean];
    
    smoothedPETH = conv(meanEventVector,window(@gausswin,slidingWindowSize, alpha),'valid')/sum(gausswin(slidingWindowSize, alpha))*100*60;
    smoothDiff = length(meanEventVector_orig) - length(smoothedPETH);
    corrXvaluesForPETH = (forAlignedYesNo+1+smoothDiff/2:length(meanEventVector_orig)-smoothDiff/2+forAlignedYesNo)*10/1000;
else
    smoothedPETH=[];
    smoothDiff = [];
    corrXvaluesForPETH = [];
end
if isempty(corrXvaluesForPETH) == 1
    corrXvaluesForPETH = [];
    smoothedPETH = [];
elseif doubleSmooth==1
    XValueCorrection = corrXvaluesForPETH(1);
    [corrXvaluesForPETH, smoothedPETH] = makeSmoothedPETH_noGapExperimental(smoothedPETH/100/60,doubleSmoothWindow,alpha,forAlignedYesNo,tossUnengagedTrials,0,doubleSmoothWindow, trimStackYN);
    corrXvaluesForPETH = corrXvaluesForPETH + XValueCorrection;
end

end