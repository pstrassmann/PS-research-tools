%Written by Patrick Strassmann

function plotRaster2(eventTimesStack, shiftValue, color, lineWidth)
%%
% Accepts two types of matrices:
%1) A matrix of ones and zeros, where rows are trials and columns are time bins.
% Example:
%     sampleMatrix = rand(100)>0.5;
%     figure; plotRaster2(sampleMatrix);

%2) A matrix of ascending timestamps, where rows are trials and columns are timestamps.
%Example:
% [[1 5 26 30 100];[10 25 269 2001]] etc. 

%

%%
changeTimeUnits = 10/1000; %If data is in 10ms bins, use this correction factor to convert to convert to seconds
if nargin<4
    lineWidth = 1;
end

if nargin<3
    color = 'k';
end

if nargin<2
    shiftValue = 0;
end

if sum(eventTimesStack(:)>1)==0 %if eventTimesStack onyl contains 1s and 0s... (is not a Times stack but rather a Matrix stack)
    eventTimesStack = makeTimesStack(eventTimesStack);
end

    %% converts trailing zeros in each event time trial to nans
    for i = 1:size(eventTimesStack,1)
        lastValidEventTimeIndInTrial = find(eventTimesStack(i,:)~=0,1,'last');
        if isempty(lastValidEventTimeIndInTrial)
            eventTimesStack(i,:) = nan;
        end
        if lastValidEventTimeIndInTrial ~= numel(eventTimesStack(i,:))
            eventTimesStack(i,lastValidEventTimeIndInTrial+1:end)=nan;
        end
    end
    %%

if isempty(eventTimesStack)==0
    z = sum(~isnan(eventTimesStack),2);
    YValues = repmat([0 0 nan],1,sum(z));
    XValues = repmat([0 0 nan],1,sum(z));
    currInd1 = 1;
    currInd2 = 2;
    for i = 1:size(z,1)
        YValues(currInd1:3:z(i)*3+currInd1)= i - 0.3;
        YValues(currInd2:3:z(i)*3+currInd2)= i + 0.3;
        currInd1 = z(i)*3+currInd1;
        currInd2 = z(i)*3+currInd2;
    end
    YValues= YValues(1:end-2);

    vectorizedPressTimes = (eventTimesStack' + shiftValue)*changeTimeUnits;
    vectorizedPressTimes = vectorizedPressTimes(:);
    vectorizedPressTimes(isnan(vectorizedPressTimes))=[];

    XValues(1:3:end) = vectorizedPressTimes';
    XValues(2:3:end) = vectorizedPressTimes' ;
    rasterLine = line(XValues,YValues);
    set(rasterLine,'LineWidth',lineWidth,'Color',color);
end

