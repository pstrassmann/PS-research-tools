% Written by Patrick Strassmann

% Start by loading your MEDPC data, setting your final data matrix to
% 'datamatrix'

dataMatrix;
wantPlots = 0;
totalTime = 360000; %Session time in 10ms bins/ total time = 1 hour
binSize =   totalTime/2; %totalTime/12; % Set to 30 minutes

[rows columns] = size(dataMatrix);
reshapedData = reshape(dataMatrix', 1, rows*columns);
reshapedData(reshapedData==0)=[]; %gets rid of zeros
actionTimes = fix(reshapedData);
actionTypes = reshapedData-actionTimes;
sessionTime = sum(actionTimes)*10/100/60;

eventCodes = [0.11 0.12 0.13 0.14 0.15 0.16 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42];

eventValueMatrix = zeros(length(eventCodes),sum(actionTimes));

cumSumActionTimes = cumsum(actionTimes);
for i=1:length(eventCodes)
    eventIndices = find(actionTypes>eventCodes(i)-0.005 & actionTypes<=eventCodes(i)+0.005);
    eventValueMatrix(i,cumSumActionTimes(eventIndices))=1;
end

white1 = find(eventValueMatrix(1,:)==1);
white2 = find(eventValueMatrix(2,:)==1);
white3 = find(eventValueMatrix(3,:)==1);
white4 = find(eventValueMatrix(4,:)==1);
white5 = find(eventValueMatrix(5,:)==1);
white6 = find(eventValueMatrix(6,:)==1);
black1 = find(eventValueMatrix(7,:)==1);
black2 = find(eventValueMatrix(8,:)==1);
black3 = find(eventValueMatrix(9,:)==1);
black4 = find(eventValueMatrix(10,:)==1);
black5 = find(eventValueMatrix(11,:)==1);
black6 = find(eventValueMatrix(12,:)==1);
irBreak_stim = find(eventValueMatrix(13,:)==1);
irBreak_safe = find(eventValueMatrix(14,:)==1);
stimToSafe = find(eventValueMatrix(15,:)==1);
safeToStim = find(eventValueMatrix(16,:)==1);
stimOn = find(eventValueMatrix(17,:)==1);
stimOff = find(eventValueMatrix(18,:)==1);

if numel(safeToStim)>numel(stimToSafe)
    safeTimesSpent = [safeToStim(1) safeToStim(2:end)-stimToSafe];
    stimToSafe = [stimToSafe totalTime];
    stimTimesSpent = stimToSafe-safeToStim;   
else
    stimTimesSpent = stimToSafe-safeToStim;
    safeToStim = [safeToStim totalTime];
    safeTimesSpent = [safeToStim(1) safeToStim(2:end)-stimToSafe];
end

sum([safeTimesSpent stimTimesSpent]);

myMat_safe = nan(1,totalTime/binSize);
myMat_stim = nan(1,totalTime/binSize);

subValue_safe = 0;
subValue_stim = 0;
for nLoop = 1:totalTime/binSize
    bin = nLoop*binSize;
    
firstInd_stimToSafe = find(stimToSafe>bin,1,'first');
firstInd_safeToStim = find(safeToStim>bin,1,'first');

if isequal(firstInd_stimToSafe,firstInd_safeToStim)
    %Which firstInd used doesn't matter
    totalSafeTimeSpent_preBin = sum(safeTimesSpent(1:firstInd_stimToSafe-1))+bin-stimToSafe(firstInd_stimToSafe-1);
    totalStimTimeSpent_preBin = sum(stimTimesSpent(1:firstInd_stimToSafe-1));
elseif firstInd_safeToStim>firstInd_stimToSafe
    %Which firstInd used MATTERS
    totalSafeTimeSpent_preBin = sum(safeTimesSpent(1:firstInd_safeToStim-1));
    totalStimTimeSpent_preBin = sum(stimTimesSpent(1:firstInd_stimToSafe-1))+bin-safeToStim(firstInd_safeToStim-1);
elseif isempty(firstInd_safeToStim)
        lastInd_safeToStim = find(safeToStim>bin-binSize,1,'last');
     if isempty(lastInd_safeToStim)
        totalSafeTimeSpent_preBin;
        totalStimTimeSpent_preBin = sum(stimTimesSpent(1:firstInd_stimToSafe-1))+bin-safeToStim(end);     
     else
        totalSafeTimeSpent_preBin = sum(safeTimesSpent(1:lastInd_safeToStim));
        totalStimTimeSpent_preBin = sum(stimTimesSpent(1:firstInd_stimToSafe-1))+bin-safeToStim(lastInd_safeToStim);  
     end

elseif isempty(firstInd_stimToSafe)
     lastInd_stimToSafe = find(stimToSafe>bin-binSize,1,'last');
     if isempty(lastInd_stimToSafe)
        totalStimTimeSpent_preBin;
        totalStimTimeSpent_preBin = sum(stimTimesSpent(1:firstInd_stimToSafe-1))+bin-stimToSafe(end);     
     else
        totalStimTimeSpent_preBin = sum(stimTimesSpent(1:lastInd_stimToSafe));
        totalSafeTimeSpent_preBin = sum(safeTimesSpent(1:firstInd_safeToStim-1))+bin-stimToSafe(lastInd_stimToSafe);  
     end
else
    error('Grave error')
end

if bin>=totalTime; totalSafeTimeSpent_preBin = sum(safeTimesSpent); end;
if bin>=totalTime; totalStimTimeSpent_preBin = sum(stimTimesSpent); end;


totalSafeTimeSpent_postBin = sum(safeTimesSpent)-totalSafeTimeSpent_preBin;
totalStimTimeSpent_postBin = sum(stimTimesSpent)-totalStimTimeSpent_preBin;

myMat_safe(nLoop) = totalSafeTimeSpent_preBin-subValue_safe;
myMat_stim(nLoop) = totalStimTimeSpent_preBin-subValue_stim;

subValue_safe = myMat_safe(nLoop)+subValue_safe;
subValue_stim = myMat_stim(nLoop)+subValue_stim;

end

pctOccupancyInBins = myMat_stim./(myMat_safe+myMat_stim)*100;
pctOccupancyInBins'

subjNum = ['subj' subjectNumber];
extractedRTCPPData_FS.(subjNum).pctOccupancyInBins = pctOccupancyInBins;

if wantPlots == 1
figure; 
plot(pctOccupancyInBins,'-o','color','k','markersize',6); 
ylabel('% Occupancy Stim Side'); ylim([0 100]);
xlabel('Bin #');
set(gca,'xtick',[1:1:totalTime/binSize],'fontsize',15);
end

