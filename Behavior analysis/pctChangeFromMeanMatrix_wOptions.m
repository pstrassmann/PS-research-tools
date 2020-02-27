% Written by Patrick Strassmann
function [pctChangeMeanData, rawChange_meanData] = pctChangeFromMeanMatrix_wOptions(SubjsByStimData_meanData,columnToNormalizeTo,deleteFirstColumn)

%For matrix M, calculates pct change of each element relative to elements
%in the first column. For stim data in particular, calcultes pct change of
%stim data relative to the no stim data of the same subject. This function
%assumes that the no stim data for each subject is in the first column,
%where each new row is the data for an individual subject

if nargin<3
    deleteFirstColumn = 0;
end

if nargin<2
    columnToNormalizeTo = 1;
end

rawChange_meanData = SubjsByStimData_meanData-repmat(SubjsByStimData_meanData(:,columnToNormalizeTo),1,size(SubjsByStimData_meanData,2));
pctChangeMeanData = zeros(size(rawChange_meanData));
for i = 1:size(rawChange_meanData,1);
pctChangeMeanData(i,:) = rawChange_meanData(i,:)/SubjsByStimData_meanData(i,columnToNormalizeTo)*100;
end
if deleteFirstColumn == 1
pctChangeMeanData = pctChangeMeanData(:,2:end);
end



end

