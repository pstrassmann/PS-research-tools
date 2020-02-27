%% Accumulator model generator with press facilitation, July 2019, Patrick Strassmann

slidingWindowSize = 499;
slidingWindowSize_tbt = slidingWindowSize*2;
sigma = slidingWindowSize;
alpha = slidingWindowSize/(2*sigma);


%Initial parameters, based on Subj15281, representative animal used in Fig 1.
numTrials = 1000;
facilitation = 0.8; % 90% facilitation
trialTimeLimit = 15001; % in centiseconds
startLatency_mean = 1294.83; % in centiseconds
startLatency_std = 743.55; % in centiseconds
meanIPI = 32.9353; % in centiseconds
stdIPI = 22.6397; % in centiseconds
meanIPI_facilitated = meanIPI * facilitation;
stdIPI_facilitated = stdIPI * facilitation;
limit = 87.2556; %Mean threshold for Subj15281 based on boutEndTimes and sigmoidal filter
limit_std = 20.8190;
defaultNumPressesGenerated = 1000;

%Initialize pressStackMatrix
pressStackMatrix_probe = zeros(numTrials, trialTimeLimit);

%Generate probability distribution for start latencies (truncated normal distribution)
probabilityDistribution = makedist('normal','mu',startLatency_mean,'sigma',startLatency_std);
pd_truncated = truncate(probabilityDistribution, 0, inf);

%Generate probability distribution for presses (truncated normal distribution)
probabilityDistribution_IPI = makedist('normal','mu',meanIPI,'sigma',stdIPI);
pd_IPI_truncated = truncate(probabilityDistribution_IPI, 0, inf);

%Generate probability distribution for presses (truncated normal distribution)
probabilityDistribution_IPI_facilitated = makedist('normal','mu',meanIPI_facilitated,'sigma',stdIPI_facilitated);
pd_IPI_truncated_facilitated = truncate(probabilityDistribution_IPI_facilitated, 0, inf);

%Generate probability distribution for threshold limite (truncated normal distribution)
probabilityDistribution_limit = makedist('normal','mu',limit,'sigma',limit_std);
pd_limit_truncated = truncate(probabilityDistribution_limit, 0, inf);

stimCenters = [0 750 2650];
stimWindowLength = 1400;

%Prep data structures for saving

extractedModelData = struct;
subjectNumber = '12345';
finalDataCell_start = cell(1,numel(stimCenters));
finalDataCell_stop = cell(1,numel(stimCenters));
finalDataCell_durations = cell(1,numel(stimCenters));
finalDataCell_numPperB = cell(1,numel(stimCenters));
finalDataCell_rasters = cell(1,numel(stimCenters));
finalDataCell_PETHs = cell(2,numel(stimCenters));

figure('position',[1         454        1680         494]);
for stimCond = 1:numel(stimCenters)

    %Randomly select start latencies from probability distribution
    startLatencies = random(pd_truncated, numTrials,1);
    
    %Randomly select start latencies from probability distribution
    pressIPIs = random(pd_IPI_truncated, numTrials,defaultNumPressesGenerated); %IF YOU WANT EXACT SAME PRESSES FOR STIM AND NON-STIM, MOVE THIS BEFORE FOR LOOP
    pressIPIs_facilitated = random(pd_IPI_truncated_facilitated, numTrials,defaultNumPressesGenerated);
    
    %Randomly select accumulation thresholds from probability distribution
    accumThresholds = random(pd_limit_truncated, numTrials,1);

    %Generate more presses than we need
    pressTimes_generated = cumsum([startLatencies pressIPIs],2);
    pressTimes_generated_facilitated = cumsum([startLatencies pressIPIs_facilitated],2);

    matStack = makeMatrixStack(pressTimes_generated);
    matStack_facilitated = makeMatrixStack(pressTimes_generated_facilitated);

    if stimCenters(stimCond) ~= 0

         matStack(:,stimCenters(stimCond)-(stimWindowLength/2-1):stimCenters(stimCond)+(stimWindowLength/2-1)) = matStack_facilitated(:,stimCenters(stimCond)-(stimWindowLength/2-1):stimCenters(stimCond)+(stimWindowLength/2-1));
         pressTimes_generated = makeTimesStack(matStack);
        
    end    

    %% Apply sigmoidal filter
    k = 1;
    x = pressTimes_generated./1000;
    pressTimes_gen_filtered = exp(x)./(1+exp(x)); %log(x)+k; %k./(1+ex;p(a+b.*x)); %exp(x)./(1+exp(x)); %(1500+x);
    
    %% Accumulator and Thresholding
    cumPressTimes = cumsum(pressTimes_gen_filtered,2);
    for i = 1:size(cumPressTimes,1)
       thresholdPassed_firstInd = find(cumPressTimes(i,:)>accumThresholds(i),1,'first')+1;
       eliminatedSize = numel((pressTimes_generated(i,thresholdPassed_firstInd:end)));
       pressTimes_generated(i,thresholdPassed_firstInd:end) = zeros(1,eliminatedSize);
    end
    pressTimes_generated = trimStack(pressTimes_generated);
    
    
    %% Determine Start, Stop, Duration, Peak, Midpoint, #P/Seq
    %Start
    boutStartTimes = pressTimes_generated(:,1);
    %Stop
    boutStopTimes = zeros(numel(boutStartTimes),1);
    for i = 1:numel(boutStartTimes)
        singTrial = pressTimes_generated(i,:);
        jj = find(singTrial>0,1,'last');
        boutStopTimes(i) = singTrial(jj);
    end
    
    %Durations
    boutDurations = boutStopTimes-boutStartTimes;
    %Midpoints
    boutMidpoints = (boutStopTimes+boutStartTimes)/2;
    %PressesPerSeq
    pressesPerSeq = sum(pressTimes_generated>0,2);
    %% Generate PETH
    matStack = makeMatrixStack(pressTimes_generated);
    [XValues_PETH_probe, PETH_probe] = makeSmoothedPETH_noGapExperimental(matStack, slidingWindowSize, alpha, 0,1, 1);
    
    finalDataCell_rasters{stimCond} = pressTimes_generated;
    finalDataCell_PETHs{1,stimCond} = XValues_PETH_probe;
    finalDataCell_PETHs{2,stimCond} = PETH_probe;

        %% Save data
    finalDataCell_start{stimCond} = boutStartTimes;
    finalDataCell_stop{stimCond} = boutStopTimes;
    finalDataCell_durations{stimCond} = boutDurations;
    finalDataCell_numPperB{stimCond} = pressesPerSeq;
    finalDataCell_rasters{stimCond} = pressTimes_generated;
    finalDataCell_PETHs{1,stimCond} = XValues_PETH_probe;
    finalDataCell_PETHs{2,stimCond} = PETH_probe;
    
    currFieldName = ['s' num2str(stimCond)];
    subjectNum_subj = ['Subj' subjectNumber];
    currStimProt = [stimCenters(stimCond)-stimWindowLength/2 stimWindowLength];
    if stimCenters(stimCond) == 0
        extractedModelData.(subjectNum_subj).pressStackMatrix_probe = matStack;
        extractedModelData.(subjectNum_subj).boutDurations_probe = boutDurations';
        extractedModelData.(subjectNum_subj).boutEndTimes_probe = boutStopTimes';
        extractedModelData.(subjectNum_subj).boutStartTimes_probe = boutStartTimes';
        extractedModelData.(subjectNum_subj).XValues_PETH_probe = XValues_PETH_probe;
        extractedModelData.(subjectNum_subj).PETH_probe = PETH_probe;
    else
        extractedModelData.(subjectNum_subj).(currFieldName).pressStackMatrix_probeStm = matStack;
        extractedModelData.(subjectNum_subj).(currFieldName).boutDurations_probeStm = boutDurations';
        extractedModelData.(subjectNum_subj).(currFieldName).boutEndTimes_probeStm = boutStopTimes';
        extractedModelData.(subjectNum_subj).(currFieldName).boutStartTimes_probeStm = boutStartTimes';
        extractedModelData.(subjectNum_subj).(currFieldName).XValues_PETH_probeStm = XValues_PETH_probe;
        extractedModelData.(subjectNum_subj).(currFieldName).PETH_probeStm = PETH_probe;
        extractedModelData.(subjectNum_subj).(currFieldName).currStimProt = currStimProt;
    end
    
%% Plotting
numStimCond = numel(stimCenters);
subplot(2,numStimCond,stimCond);
if stimCond == 1
plotRaster2(pressTimes_generated); ylim([0 numTrials]); xlim([0 150]);
ylabel('Trial #');
set(gca,'xticklabel',[]); set(gca, 'ytick',[0:200:numTrials]); set(gca, 'fontsize',16);
subplot(2,numStimCond,stimCond+numStimCond);
plot(XValues_PETH_probe,PETH_probe,'k','linewidth',3);
ylabel('Presses/min');
else
plotRaster2(pressTimes_generated,0,'r'); ylim([0 numTrials]); xlim([0 150]);
set(gca,'xticklabel',[]); set(gca, 'ytick',[0:200:numTrials]); set(gca, 'fontsize',16);
subplot(2,numStimCond,stimCond+numStimCond);
plot(finalDataCell_PETHs{1,1},finalDataCell_PETHs{2,1},'k','linewidth',3);
hold on;
plot(XValues_PETH_probe,PETH_probe,'r','linewidth',3);
end
hold on;
set(gca,'xtick',[0:30:150]); 
xlim([0 150]); %ylim([0 175]);
dottedVertLine(30);
xlabel('Time (s)');
set(gca,'fontsize',16);
end    
spaceplots([.01 .01 .01 .01], [.01 .01]);

figure;
plotCorr(finalDataCell_start(1), finalDataCell_stop(1)); xlim([0 3000]); ylim([2000 8000 ]);








