%Written by Patrick Strassmann

function [boutStartXs, boutStartYs, boutEndXs, boutEndYs] = markBoutBounderies(boutStartTimes, boutEndTimes,markerSize)

scaleFactor = 1;

if nargin<3
    markerSize = 4;
end

if nanmean(boutEndTimes)>1000
    boutEndTimes = boutEndTimes/100;
    boutStartTimes = boutStartTimes/100;
    display('rescaling end and start times in markBoutBounderies');
end

for i=1:length(boutStartTimes)
    if isnan(boutStartTimes(i))==0
        hold on;
    plot(boutStartTimes(i)*scaleFactor,i,'Marker','o','MarkerSize',markerSize,'linewidth',1,'MarkerFaceColor',rgb('lime'),'MarkerEdgeColor','k');
    end
    
    if isnan(boutEndTimes(i))==0
        hold on;
    plot(boutEndTimes(i)*scaleFactor,i,'Marker','o','MarkerSize',markerSize,'linewidth',1,'MarkerFaceColor',rgb('red'), 'MarkerEdgeColor','k');
    end
end

noNanStartInds = ~isnan(boutStartTimes);
boutStartXs = boutStartTimes(noNanStartInds);
boutStartYs = 1:numel(boutStartTimes);
boutStartYs = boutStartYs(noNanStartInds);

noNanEndInds = ~isnan(boutEndTimes);
boutEndXs = boutEndTimes(noNanEndInds);
boutEndYs = 1:numel(boutEndTimes);
boutEndYs = boutEndYs(noNanEndInds);
end
