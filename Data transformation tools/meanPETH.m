% Written by Patrick Strassmann
function [xValues, meanPETHY, lowerShadow, upperShadow] = meanPETH(cellOfPETHs_X, cellOfPETHs_Y, shiftValue, trialTimeLimit, wantPlot,color,pethScaleFactor)
if nargin<7
    pethScaleFactor=1;
end

if nargin<6
    color = rgb('black');
    if nargin<4
        wantPlot=0;
    end
end

cellOfPETHs_X = cellOfPETHs_X(~cellfun('isempty',cellOfPETHs_X));
cellOfPETHs_Y = cellOfPETHs_Y(~cellfun('isempty',cellOfPETHs_Y));

numXValues = cellfun(@numel,cellOfPETHs_X);
ultMin = min(cell2mat(cellfun(@min,cellOfPETHs_X,'un',0)))*100;
ultMax = max(cell2mat(cellfun(@max,cellOfPETHs_X,'un',0)))*100;
realTimeFrame = ultMin:1:ultMax;

matOfPETHs = nan(numel(cellOfPETHs_Y),numel(realTimeFrame));
for i=1:numel(cellOfPETHs_Y)
    currPETH = cellOfPETHs_Y{i};
    startXForCurrPETH = min(cellOfPETHs_X{i});
    endXForCurrPETH = max(cellOfPETHs_X{i});
    startInd = 1;
    stopInd = numel(realTimeFrame); 
    matOfPETHs(i,startInd:stopInd) = currPETH;
end

xValues = realTimeFrame*10/1000*pethScaleFactor;
xValues = xValues + shiftValue*pethScaleFactor;
matOfPETHs = trimStack(matOfPETHs);
meanPETHY = nanmean(matOfPETHs);
errorPETH = std(matOfPETHs); % STD
lowerShadow = meanPETHY-errorPETH;
upperShadow = meanPETHY+errorPETH;
if wantPlot==1
    shadedErrorBar(xValues,meanPETHY,errorPETH,{'color',color,'linewidth',3},1,0.1);
end

