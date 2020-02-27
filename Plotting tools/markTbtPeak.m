%Written by Patrick Strassmann
function [] = markTbtPeak(tbtPkValues, XValues_PETH,YValues_PETH,shiftValue)

if nargin<4
    shiftValue = 0;
end
shiftValue = shiftValue*10/1000;
    tbtMeanPeak = mean(noNans(tbtPkValues)).*10/1000;
    closeAfter = find(XValues_PETH+shiftValue>tbtMeanPeak,1,'first');
    closeBefore = find(XValues_PETH+shiftValue<tbtMeanPeak,1,'last');
    yValue = (YValues_PETH(closeBefore)+YValues_PETH(closeAfter))/2;
    hold on;
    plot(mean(noNans(tbtPkValues))*10/1000,yValue,'ko','LineWidth',1,'MarkerFaceColor','m'); hold on;
    
end

