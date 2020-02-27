%Written by Patrick Strassmann

function [] = paramSurf2(dataMat,unAlignedOrAligned)
if nargin<2
    unAlignedOrAligned = 1;
end
if unAlignedOrAligned ~= 1 && unAlignedOrAligned ~=2
    error('Second paramter must be 1 or 2')
end
dataMat([1 2 4 5],:)=dataMat([1 2 4 5],:).*10/1000;
dataMatNoPeak = dataMat(4:end,:);
valueMat = nan(2,4);
varRows = [];
indMarker = 1;
for i=1:size(dataMatNoPeak,1)
    if numel(unique(dataMatNoPeak(i,:)))>1
        varRows = vertcat(varRows,i);
        numUniqueEl = numel(unique(dataMatNoPeak(i,:)));
        minVal = min(dataMatNoPeak(i,:));
        maxVal = max(dataMatNoPeak(i,:));
        diff = ((maxVal-minVal)/(numUniqueEl-1));
        if indMarker ==1
            valueMat(indMarker,1) = numUniqueEl;
            valueMat(indMarker,2) = minVal;
            valueMat(indMarker,3) = maxVal;
            valueMat(indMarker,4) = diff;
            indMarker = 2;
        else
            valueMat(indMarker,1) = numUniqueEl;
            valueMat(indMarker,2) = minVal;
            valueMat(indMarker,3) = maxVal;
            valueMat(indMarker,4) = diff;
        end
    end
end
reshapeDim = numel(unique(dataMatNoPeak(varRows(end),:)));
peakVals = dataMat(unAlignedOrAligned,:);
reshapedPeakVals = reshape(peakVals,reshapeDim,[]);
labels = {'Mean Start Latency (s)'; 'Std Start Latency (s)'; 'Mean Presses/Bout'; 'Std Presses/Bout'; 'Mean IPI'; 'Std IPI'};
mainPlot = figure('position',[6         391        1319         573]);
subplot(1,2,1)
surf(reshapedPeakVals)
set(gca,'XTick',0:9:valueMat(1,1))
set(gca,'XTickLabel',valueMat(1,2):valueMat(1,4)*9:valueMat(1,3))
xlabel(labels{varRows(1)})
set(gca,'YTick',0:10:valueMat(2,1))
set(gca,'YTickLabel',valueMat(2,2):valueMat(2,4)*10:valueMat(2,3))
ylabel(labels{varRows(2)})
zlabel('Peak Location (s)')
subplot(1,2,2)
imagesc(reshapedPeakVals)
xlabel(labels{varRows(1)})
set(gca,'XTick',0:9:valueMat(1,1))
set(gca,'XTickLabel',valueMat(1,2):valueMat(1,4)*9:valueMat(1,3))
ylabel(labels{varRows(2)})
set(gca,'YTick',0:10:valueMat(2,1))
set(gca,'YTickLabel',valueMat(2,2):valueMat(2,4)*10:valueMat(2,3))
spaceplots([.01 .01 .01 .01]);
colorbar()
end

