%Written by Patrick Strassmann

function [] = lineScatter(inputCell,errorType,jitter,barColor, errorLineColor, markerColorList)
%% Input can be either a matrix or a cell containing multiple vectors:
% As matrix: (Each row of matrix treated as independent data vector)
%       data = rand(5,10); barScatter(data)
% As cell: (Each row in cell treated as independent data vector)
%       dataVector1 = rand(1,10);
%       dataVector2 = rand(1,35);
%       barScatter({dataVector1; dataVector2})

%% Only one input is necessary. Second Input can specify to use std or sem. Default is std.
%       dataVector1 = rand(1,10);
%       dataVector2 = rand(1,35);
%       input = {dataVector1; dataVector2};
%       barScatter(input) OR barScatter(input,'sem') OR  barScatter(input,'std');

%  Add jitter for better visualization. Jitter seems to work well if set from 0-1. Try 1 or 0.5 at first
%  Example w/ jitter:
%data = rand(3,10); figure; barScatter(data,'sem',0.2);

%  Example w/ different colors:
%       data = rand(3,10); figure; barScatter(data,'sem',0.2,'g','k','m');

%  Example w/ numeric colors: data = rand(3,10); figure;  barScatter(data,'sem',0.2, [0.2539    0.4102    0.8789],[0 0 0],[1 0 0]);

if nargin<2
    errorType = 'std';
end
if nargin<3
    jitter = 0;
end
if nargin<4
    barColor = [0.2539    0.4102    0.8789];
end
if nargin<5
    errorLineColor = barColor;
%     errorLineColor = [0 0 0];
end
if nargin<6
    markerColorList = repmat(rgb('red'),size(inputCell,1),1);
end
if isequal(class(inputCell),'double')
    inputCell = num2cell(inputCell,2);
end
meanVect = cellfun(@nanmean,inputCell);
if isequal(lower(errorType),'std')
    errorVect = cellfun(@nanstd,inputCell); % USE STD
elseif isequal(lower(errorType),'sem')
    errorVect = cellfun(@(x) sem(x,2),inputCell); % USE SEM
else
    error('Second argument (errorType) must be either ''sem'' or ''std''')
end

for i=1:numel(meanVect)
    errorLine = line([i i],[meanVect(i)+errorVect(i) meanVect(i)-errorVect(i)]); hold on;
    set(errorLine,'linewidth',2)
    set(errorLine,'color',errorLineColor);
    if jitter>=0
        plot(ones(1,numel(inputCell{i}))*i+randn(1,numel(inputCell{i}))*.1*jitter,inputCell{i},'ko','MarkerFaceColor',markerColorList(i,:));
    end
end
hold on;
plot(meanVect','color',barColor,'linewidth',3,'Marker','.','MarkerFaceColor',barColor); axis tight;
xlim([0 numel(meanVect)+1]);
% set(gca,'xticklabel',[]);

