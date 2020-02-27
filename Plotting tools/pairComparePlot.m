%Written by Patrick Strassmann
function [] = pairComparePlot(inputCell,colorList)

if nargin<2
    numElements = max(cellfun(@numel,inputCell(:,1)));
    colorList = hsv(numElements);
end

[numRows, numCols] = size(inputCell);
if numCols~=2
    error('Number of cols in inputCell must equal 2');
end

for i = 1:numRows
        beforeVect = inputCell{i,1};
        afterVect = inputCell{i,2};
        if numel(beforeVect)~=numel(afterVect)
            error('Columns within a given row must contain the same number of elements');
        end
        display(i);
    for j = 1:numel(beforeVect)
        plot([i-.3 i+.3], [beforeVect(j) afterVect(j)],'ko-','markersize',7,'markerfacecolor',colorList(j,:)); hold on;
    end
end
end

