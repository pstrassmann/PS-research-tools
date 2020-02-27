% Written by Patrick Strassmann
function [alignedDopamineMatrix, corrVal_aligned, interpolatedDopamineTrials, alignedPETH_X, alignedPETH_Y] = alignDopamineTrials(trials,invalidTrials, alignPoints, trialTimeLimit)
slidingWindowSize = 299;
sigma = slidingWindowSize;
alpha = slidingWindowSize/(2*sigma);
trials_norm = bsxfun(@minus,trials',trials(1,:)');
interpolatedDopamineTrials = interpolateDopamine(trials_norm);
if ~isempty(invalidTrials)
    interpolatedDopamineTrials(invalidTrials,:) = [];
    alignPoints(invalidTrials) = [];    
end
interpolatedDopamineTrials = interpolatedDopamineTrials(:,501:end); display('Removing first 5 seconds of interpolated dopamine in alignedDopamine.m');
[alignedDopamineMatrix, corrVal_aligned] = noCutAlignStack_end(interpolatedDopamineTrials, alignPoints,trialTimeLimit);
[alignedPETH_X,alignedPETH_Y] = makeSmoothedPETH(alignedDopamineMatrix, slidingWindowSize, alpha, 0,0,0);
end