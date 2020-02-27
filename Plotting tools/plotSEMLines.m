% Written by Patrick Strassmann
function [] = plotSEMLines(xValues,dataCell)
for i=1:numel(xValues)
    currData = dataCell{i};
    line([xValues(i) xValues(i)], [nanmean(currData)+sem(noNans(currData)) nanmean(currData)- sem(noNans(currData))], 'Color','k');
    hold on;
end
end

