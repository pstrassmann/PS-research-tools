% Written by Patrick Strassmann

function newMeanPETH(XValues_probe_cell,PETH_probeStm_cell, color,trialTimeLimit, endArtifactCorrection)

if nargin<5
    endArtifactCorrection = 0;
end

if nargin<4
    trialTimeLimit = 15001;
end

if nargin<3
    color = rgb('black');
end

[maxPETHLength, longestXValuesInd] = max(cellfun(@numel,XValues_probe_cell));
xValues = XValues_probe_cell{longestXValuesInd,:};
matOfPETHs = nan(numel(PETH_probeStm_cell),trialTimeLimit);

for i = 1:numel(PETH_probeStm_cell)
    currPETH = PETH_probeStm_cell{i,:};
    matOfPETHs(i,1:numel(currPETH)) = currPETH;
end;

matOfPETHs = matOfPETHs(:,1:maxPETHLength);
meanPETHY = nanmean(matOfPETHs);
errorPETH = std(matOfPETHs); % STD
lowerShadow = meanPETHY-errorPETH;
upperShadow = meanPETHY+errorPETH;

xValues = xValues(1:end-endArtifactCorrection);
errorPETH = errorPETH(1:end-endArtifactCorrection);
meanPETHY = meanPETHY(1:end-endArtifactCorrection);
shadedErrorBar(xValues,meanPETHY,errorPETH,{'color',color,'linewidth',3},1,0);