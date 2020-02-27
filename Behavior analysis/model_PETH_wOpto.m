% Generate behavioral data model, including optogenetic stimulation
% Written by Patrick Strassmann
set(0, 'DefaultTextFontName', 'Arial');
set(0,'DefaultAxesFontSize',10)
wantPlots = 1; %1 = plotting will occur and plots will show, 0 = plotting will not occur and plots won't show
wantSave = 0; % will save figures if this is '1'.
wantNoPP = 0;
subjectNumber = 'MODEL';
genotype = 'MODEL';
experimentName = 'MODEL';
tossUnengagedTrials = 1;
trialTimeLimit_probe = 10001;
trialTimeLimit_rwd = 50000;
upperNumPressLimit = 1000;
simpleCut = 1;
concatOn = 0;


slidingWindowSize = 299; % this is in units of 10ms. Therefore this number is ,99 seconds when set to 99. Must be odd, so that time point is in middle of window. xxxPxxx
slidingWindowSize_tbt = slidingWindowSize*2;
sigma = 100;
alpha = slidingWindowSize/(2*sigma);
alpha_tbt = slidingWindowSize_tbt/(2*sigma);
legFontSize = 8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
criterionIPI_BoutStart_probe = 200;
criterionIPI_BoutEnd_probe = 500;
consecPresses_probe = 4;
medianFactor_probe = 0.4;

criterionIPI_BoutStart_probeStm = 200;
criterionIPI_BoutEnd_probeStm = 500;
consecPresses_probeStm = 4;
medianFactor_probeStm = 0.4;

criterionIPI_BoutStart_probeConcat = 200;%40;
criterionIPI_BoutEnd_probeConcat = 500;
consecPresses_probeConcat = 4;%6;;
medianFactor_probeConcat = 0.4;


criterionIPI_BoutStart_rwd = 200;
criterionIPI_BoutEnd_rwd = 500;
consecPresses_rwd = 4;
medianFactor_rwd = 0.6;

percentOfPeakMax = 0.9;
tbtPercentOfPeakMax = 0.80;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***************************************************************
\
optoOn=1;
stimDuration = 1000;
stimTimeOnRelToBoutStart = 300;

pressStackMatrix_probe = pooledPressStackMatrix_probe;
pressStackTimes_probe = makeTimesStack(pressStackMatrix_probe);
numTrials = size(pressStackMatrix_probe,1);

pressStackMatrix_probeStm = zeros(numTrials,trialTimeLimit_probe);
pressStackTimes_probeStm = zeros(numTrials,upperNumPressLimit);



for i = 1:numTrials
    trialPressMatrix_model = pressStackMatrix_probe(i,:);
    if optoOn ==1
        firstPressInd = find(trialPressMatrix_model,1,'first');
        stimStartInd = firstPressInd+stimTimeOnRelToBoutStart;
        trialPressMatrix_modelStm = [trialPressMatrix_model(1:stimStartInd) zeros(1,stimDuration) trialPressMatrix_model(stimStartInd+1:end)];
        if numel(trialPressMatrix_modelStm)>trialTimeLimit_probe-1
            trialPressMatrix_modelStm = trialPressMatrix_modelStm(1:trialTimeLimit_probe-1);
        end
        trialPressTimes_modelStm = find(trialPressMatrix_modelStm==1);
        pressStackMatrix_probeStm(i,:) = [trialPressMatrix_modelStm zeros(1,trialTimeLimit_probe-length(trialPressMatrix_modelStm))];
        pressStackTimes_probeStm(i,:) =  [trialPressTimes_modelStm zeros(1,upperNumPressLimit-length(trialPressTimes_modelStm))];
    end
    
    
    if numel(trialPressMatrix_model)>trialTimeLimit_probe-1
        trialPressMatrix_model = trialPressMatrix_model(1:trialTimeLimit_probe-1);
    end
    trialPressTimes_model = find(trialPressMatrix_model==1);
    
end

if optoOn==1
    probeTrialExtensionTimes_stim = 1:10001:(size(pressStackTimes_probeStm,1))*10000;
    probeTrialRetractTimes_stim = 10001:10001:(size(pressStackTimes_probeStm,1)+1)*10000;
    stimTimesOn_probe = probeTrialExtensionTimes_stim+pressStackTimes_probeStm(:,1)'+stimTimeOnRelToBoutStart;
    stimTimesOff_probe = stimTimesOn_probe+stimDuration;
end

relStimTimesOn_probe = (stimTimesOn_probe - probeTrialExtensionTimes_stim)+1;
relStimTimesOff_probe = (stimTimesOff_probe - probeTrialExtensionTimes_stim)+1;

%%

[boutStartTimes_probe, boutEndTimes_probe, boutDurations_probe, stackedBoutMatrices_probe_aligned,...
    stackedBoutTimes_probe, stackedBoutIPIs_probe, stackedBoutTimes_probe_aligned, meanBoutStartLatency_probe, stackedPressMatrices_probe_aligned_noCut, corrShiftVal_noCut_probe] = boutExtract(pressStackMatrix_probe,...
    pressStackTimes_probe , trialTimeLimit_probe ,consecPresses_probe, criterionIPI_BoutStart_probe,...
    criterionIPI_BoutEnd_probe, medianFactor_probe);

[XValues_PETH_probe, PETH_probe] = makeSmoothedPETH(pressStackMatrix_probe, slidingWindowSize, alpha, 0,tossUnengagedTrials);
[XValues_PETH_probe_aligned, PETH_probe_aligned] = makeSmoothedPETH(stackedBoutMatrices_probe_aligned, slidingWindowSize, alpha, 1,tossUnengagedTrials);

[XValues_PETH_probe_aligned_noCut, PETH_probe_aligned_noCut] = makeSmoothedPETH(stackedPressMatrices_probe_aligned_noCut, slidingWindowSize, alpha, 1,tossUnengagedTrials);

tbtPkValues_probe = tbtPeakFinder(pressStackMatrix_probe,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax,0);
tbtPkValues_probe_aligned = tbtPeakFinder(stackedBoutMatrices_probe_aligned,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax, meanBoutStartLatency_probe);

%%

%%
[boutStartTimes_probeStm, boutEndTimes_probeStm, boutDurations_probeStm, stackedBoutMatrices_probeStm_aligned,...
    stackedBoutTimes_probeStm, stackedBoutIPIs_probeStm, stackedBoutTimes_probeStm_aligned, meanBoutStartLatency_probeStm, stackedPressMatrices_probeStm_aligned_noCut, corrShiftVal_noCut_probeStm ] = boutExtract(pressStackMatrix_probeStm,...
    pressStackTimes_probeStm , trialTimeLimit_probe ,consecPresses_probeStm, criterionIPI_BoutStart_probeStm,...
    criterionIPI_BoutEnd_probeStm, medianFactor_probeStm, relStimTimesOff_probe, relStimTimesOn_probe);

[XValues_PETH_probeStm, PETH_probeStm] = makeSmoothedPETH(pressStackMatrix_probeStm, slidingWindowSize, alpha, 0,tossUnengagedTrials);
[XValues_PETH_probeStm_aligned, PETH_probeStm_aligned] = makeSmoothedPETH(stackedBoutMatrices_probeStm_aligned, slidingWindowSize, alpha, 1,tossUnengagedTrials);

[XValues_PETH_probeStm_aligned_noCut, PETH_probeStm_aligned_noCut] = makeSmoothedPETH(stackedPressMatrices_probeStm_aligned_noCut, slidingWindowSize, alpha, 1,tossUnengagedTrials);


tbtPkValues_probeStm = tbtPeakFinder(pressStackMatrix_probeStm,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax,0);
tbtPkValues_probeStm_aligned = tbtPeakFinder(stackedBoutMatrices_probeStm_aligned,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax, meanBoutStartLatency_probeStm);

%%
%% *CONCAT* probe

[pressStackMatrix_probeConcat,pressStackTimes_probeConcat] = concatStimTrials(pressStackMatrix_probeStm,...
    relStimTimesOn_probe, relStimTimesOff_probe, meanIPIfromStack(stackedBoutIPIs_probe),trialTimeLimit_probe,simpleCut);

[boutStartTimes_probeConcat, boutEndTimes_probeConcat, boutDurations_probeConcat, stackedBoutMatrices_probeConcat_aligned,...
    stackedBoutTimes_probeConcat, stackedBoutIPIs_probeConcat, stackedBoutTimes_probeConcat_aligned, meanBoutStartLatency_probeConcat , stackedPressMatrices_probeConcat_aligned_noCut, corrShiftVal_noCut_probeConcat  ] = boutExtract(pressStackMatrix_probeConcat,...
    pressStackTimes_probeConcat , trialTimeLimit_probe ,consecPresses_probeConcat, criterionIPI_BoutStart_probeConcat,...
    criterionIPI_BoutEnd_probeConcat, medianFactor_probeConcat);

[XValues_PETH_probeConcat, PETH_probeConcat] = makeSmoothedPETH(pressStackMatrix_probeConcat, slidingWindowSize, alpha, 0,tossUnengagedTrials);
[XValues_PETH_probeConcat_aligned, PETH_probeConcat_aligned] = makeSmoothedPETH(stackedBoutMatrices_probeConcat_aligned, slidingWindowSize, alpha, 1,tossUnengagedTrials);

[XValues_PETH_probeConcat_aligned_noCut, PETH_probeConcat_aligned_noCut] = makeSmoothedPETH(stackedPressMatrices_probeConcat_aligned_noCut, slidingWindowSize, alpha, 1,tossUnengagedTrials);

tbtPkValues_probeConcat = tbtPeakFinder(pressStackMatrix_probeConcat,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax,0);
tbtPkValues_probeConcat_aligned = tbtPeakFinder(stackedBoutMatrices_probeConcat_aligned,slidingWindowSize_tbt, alpha_tbt, tbtPercentOfPeakMax, meanBoutStartLatency_probeConcat);


%% COMPUTE Sig Stats

meanBoutStartLatency_probe;
stdBoutStartLatency_probe = std(noNans(boutStartTimes_probe));
meanBoutDuration_probe = mean(noNans(boutDurations_probe));
stdBoutDuration_probe = std(noNans(boutDurations_probe));
meanNumPressesPerBout_probe = mean(sum(stackedBoutTimes_probe>0,2));
cvNumPressesPerBout_probe = cv(sum(stackedBoutTimes_probe>0,2));
cvNumPressesPerBout_probeStm = cv(sum(stackedBoutTimes_probeStm>0,2));
stdNumPressesPerBout_probe = std(sum(stackedBoutTimes_probe>0,2));
[meanIPI_probe, semIPI_probe, stdIPI_probe] = meanIPIfromStack(stackedBoutIPIs_probe*10/1000);
stimTimeRelBoutStart = mean(relStimTimesOn_probe-boutStartTimes_probeStm);


[h_peak_probeStm, p_peak_probeStm] = ttest2(tbtPkValues_probe, tbtPkValues_probeStm);
[h_peak_probeStm_aligned, p_peak_probeStm_aligned] = ttest2(tbtPkValues_probe_aligned, tbtPkValues_probeStm_aligned);
[h_latency_probeStm, p_latency_probeStm] = ttest2(boutStartTimes_probe, boutStartTimes_probeStm);
[h_duration_probeStm, p_duration_probeStm] = ttest2(boutDurations_probe, boutDurations_probeStm);
[h_numPressesPerBout_probeStm, p_numPressesPerBout_probeStm] = ttest2(sum(stackedBoutTimes_probe>0,2), sum(stackedBoutTimes_probeStm>0,2));


[h_peak_probeConcat, p_peak_probeConcat] = ttest2(tbtPkValues_probe, tbtPkValues_probeConcat);
[h_peak_probeConcat_aligned, p_peak_probeConcat_aligned] = ttest2(tbtPkValues_probe_aligned, tbtPkValues_probeConcat_aligned);
[h_latency_probeConcat, p_latency_probeConcat] = ttest2(boutStartTimes_probe, boutStartTimes_probeConcat);
[h_duration_probeConcat, p_duration_probeConcat] = ttest2(boutDurations_probe, boutDurations_probeConcat);
[h_numPressesPerBout_probeConcat, p_numPressesPerBout_probeConcat] = ttest2(sum(stackedBoutTimes_probe>0,2), sum(stackedBoutTimes_probeConcat>0,2));


sigMat_probeStm = [h_peak_probeStm h_latency_probeStm h_duration_probeStm h_numPressesPerBout_probeStm];
sigMat_probeStm_aligned = [h_peak_probeStm_aligned h_latency_probeStm h_duration_probeStm h_numPressesPerBout_probeStm];

sigMat_probeConcat = [h_peak_probeConcat h_latency_probeConcat h_duration_probeConcat h_numPressesPerBout_probeConcat];
sigMat_probeConcat_aligned = [h_peak_probeConcat_aligned h_latency_probeConcat h_duration_probeConcat h_numPressesPerBout_probeConcat];

cvBoutDurations_probe = cv(boutDurations_probe);
cvBoutStartLatency_probe = cv(boutStartTimes_probe);
cvTbtPkValues_probe = cv(tbtPkValues_probe);
cvTbtPkValues_probe_aligned = cv(tbtPkValues_probe_aligned);

cvBoutDurations_probeStm = cv(boutDurations_probeStm);
cvBoutStartLatency_probeStm = cv(boutStartTimes_probeStm);
cvTbtPkValues_probeStm = cv(tbtPkValues_probeStm);
cvTbtPkValues_probeStm_aligned = cv(tbtPkValues_probeStm_aligned);

cvBoutDurations_probeConcat = cv(boutDurations_probeConcat);
cvBoutStartLatency_probeConcat = cv(boutStartTimes_probeConcat);
cvTbtPkValues_probeConcat = cv(tbtPkValues_probeConcat);
cvTbtPkValues_probeConcat_aligned = cv(tbtPkValues_probeConcat_aligned);

stimDuration = (stimTimesOff_probe(1)-stimTimesOn_probe(1))/100;

                                 %% PLOTS
if wantPlots ==1
    
    %% PROBE
    mainPlot_probe = figure('position',[ 31         100        1222         867]);
    set(mainPlot_probe,'defaultLineLineWidth',1);
    subplot(4,6,1)
    plotRaster2(pressStackTimes_probe,0,'k'); xlim([0 100]); hold on;
    %markBoutBounderies(boutStartTimes_probe, boutEndTimes_probe);
    title('No stim');
    
    subplot(4,6,2)
    plotRaster2(pressStackTimes_probeStm,0,'r'); xlim([0 100]); hold on;
    findStimPatches(probeTrialExtensionTimes_stim, probeTrialRetractTimes_stim, stimTimesOn_probe, stimTimesOff_probe); hold on;
    %markBoutBounderies(boutStartTimes_probeStm, boutEndTimes_probeStm);
    title('Stim');
    
    subplot(4,6,3)
    plotRaster2(pressStackTimes_probeConcat,0,rgb('royalblue')); xlim([0 100]); hold on;
    %markBoutBounderies(boutStartTimes_probeConcat, boutEndTimes_probeConcat);
    title('Concat stim');
    
    subplot(4,6,4)
    plotRaster2(stackedBoutTimes_probe_aligned,meanBoutStartLatency_probe,'k'); xlim([0 100]); hold on;
    title('No stim, bout aligned');
    
    subplot(4,6,5)
    plotRaster2(stackedBoutTimes_probeStm_aligned,meanBoutStartLatency_probeStm,'r'); xlim([0 100]); hold on;
    findStimPatches(probeTrialExtensionTimes_stim, probeTrialRetractTimes_stim, stimTimesOn_probe, stimTimesOff_probe, boutStartTimes_probeStm); hold on;
    title('Stim, bout aligned');
    
    subplot(4,6,6)
    plotRaster2(stackedBoutTimes_probeConcat_aligned,meanBoutStartLatency_probeConcat,rgb('royalblue')); xlim([0 100]); hold on;
    title('Concat stim, bout aligned');
    
    subplot(4,6,7)
    plot(XValues_PETH_probe, PETH_probe,'k'); xlim([0 100]); thirtyLine; hold on;
    markCriterionPeak(XValues_PETH_probe,PETH_probe, 0, percentOfPeakMax);
    markTbtPeak(tbtPkValues_probe,XValues_PETH_probe,PETH_probe);
    plotStatsLabels(stackedBoutTimes_probe, boutStartTimes_probe, boutDurations_probe,tbtPkValues_probe);
    ylimit=ylim();
    
    subplot(4,6,8)
    plot(XValues_PETH_probeStm, PETH_probeStm,'r'); xlim([0 100]); thirtyLine; hold on;
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm);
    ylim(ylimit);
    markCriterionPeak(XValues_PETH_probeStm,PETH_probeStm, 0, percentOfPeakMax); hold on;
    markTbtPeak(tbtPkValues_probeStm,XValues_PETH_probeStm,PETH_probeStm);
    plotStatsLabels(stackedBoutTimes_probeStm, boutStartTimes_probeStm, boutDurations_probeStm,tbtPkValues_probeStm, sigMat_probeStm);
    
    subplot(4,6,9)
    plot(XValues_PETH_probeConcat, PETH_probeConcat, 'Color',rgb('royalblue')); xlim([0 100]); thirtyLine; hold on;
    markCriterionPeak(XValues_PETH_probeConcat,PETH_probeConcat, 0, percentOfPeakMax);
    markTbtPeak(tbtPkValues_probeConcat,XValues_PETH_probeConcat,PETH_probeConcat);
    plotStatsLabels(stackedBoutTimes_probeConcat, boutStartTimes_probeConcat, boutDurations_probeConcat,tbtPkValues_probeConcat, sigMat_probeConcat);
    
    subplot(4,6,10)
    plot(XValues_PETH_probe_aligned+meanBoutStartLatency_probe*10/1000, PETH_probe_aligned,'k'); xlim([0 100]); thirtyLine; hold on;
    markCriterionPeak(XValues_PETH_probe_aligned,PETH_probe_aligned, meanBoutStartLatency_probe, percentOfPeakMax);
    markTbtPeak(tbtPkValues_probe_aligned,XValues_PETH_probe_aligned,PETH_probe_aligned,meanBoutStartLatency_probe);
    plotStatsLabels(stackedBoutTimes_probe, boutStartTimes_probe, boutDurations_probe,tbtPkValues_probe_aligned);
    
    subplot(4,6,11)
    plot(XValues_PETH_probeStm_aligned+meanBoutStartLatency_probeStm*10/1000, PETH_probeStm_aligned,'r'); xlim([0 100]); thirtyLine; hold on;
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm, meanBoutStartLatency_probeStm);
    markCriterionPeak(XValues_PETH_probeStm_aligned,PETH_probeStm_aligned, meanBoutStartLatency_probeStm, percentOfPeakMax);
    markTbtPeak(tbtPkValues_probeStm_aligned,XValues_PETH_probeStm_aligned,PETH_probeStm_aligned,meanBoutStartLatency_probeStm);
    plotStatsLabels(stackedBoutTimes_probeStm, boutStartTimes_probeStm, boutDurations_probeStm,tbtPkValues_probeStm_aligned, sigMat_probeStm_aligned);
    
    subplot(4,6,12)
    plot(XValues_PETH_probeConcat_aligned+meanBoutStartLatency_probeConcat*10/1000, PETH_probeConcat_aligned,'Color',rgb('royalblue')); xlim([0 100]); thirtyLine; hold on;
    markCriterionPeak(XValues_PETH_probeConcat_aligned,PETH_probeConcat_aligned, meanBoutStartLatency_probeConcat, percentOfPeakMax);
    markTbtPeak(tbtPkValues_probeConcat_aligned,XValues_PETH_probeConcat_aligned,PETH_probeConcat_aligned,meanBoutStartLatency_probeConcat);
    plotStatsLabels(stackedBoutTimes_probeConcat, boutStartTimes_probeConcat, boutDurations_probeConcat,tbtPkValues_probeConcat_aligned,sigMat_probeConcat_aligned);
    
    set(mainPlot_probe,'defaultLineLineWidth',2);
    subplot(4,6,13:15)
    plot(XValues_PETH_probe, PETH_probe,'k');  hold on;
    plot(XValues_PETH_probeStm, PETH_probeStm,'r'); hold on;
    plot(XValues_PETH_probeConcat, PETH_probeConcat, 'Color',rgb('royalblue')); hold on;
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm);
    xlim([0 100]); thirtyLine; hold on;
    title('No stim/Stim/Concat stim Overlay');
    
    subplot(4,6,16:18)
    plot(XValues_PETH_probe_aligned+meanBoutStartLatency_probe*10/1000, PETH_probe_aligned,'k');  hold on;
    plot(XValues_PETH_probeStm_aligned+meanBoutStartLatency_probeStm*10/1000, PETH_probeStm_aligned,'r'); hold on;
    plot(XValues_PETH_probeConcat_aligned+meanBoutStartLatency_probeConcat*10/1000, PETH_probeConcat_aligned, 'Color',rgb('royalblue'));
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm, meanBoutStartLatency_probeStm);
    xlim([0 100]); thirtyLine; hold on;
    title('Aligned No stim/Stim/Concat stim Overlay');
    
    subplot(4,6,19:21)
    plot(XValues_PETH_probe, makeNorm(PETH_probe),'k');  hold on;
    plot(XValues_PETH_probeStm*(mean(noNans(tbtPkValues_probe))/mean(noNans(tbtPkValues_probeStm))), makeNorm(PETH_probeStm),'r'); hold on;
    plot(XValues_PETH_probeConcat*(mean(noNans(tbtPkValues_probe))/mean(noNans(tbtPkValues_probeConcat))), makeNorm(PETH_probeConcat), 'Color',rgb('royalblue'));
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm);
    xlim([0 100]); thirtyLine; hold on;
    set(gca,'xtick',[30]);
    set(gca,'xticklabel',['Norm tbt peak time']);
    title('Normalized No stim/Stim/Concat stim Overlay');
    
    subplot(4,6,22:24)
    plot(XValues_PETH_probe_aligned+meanBoutStartLatency_probe*10/1000, makeNorm(PETH_probe_aligned),'k');  hold on;
    plot((XValues_PETH_probeStm_aligned+meanBoutStartLatency_probeStm*10/1000)*((mean(noNans(tbtPkValues_probe_aligned))/mean(noNans(tbtPkValues_probeStm_aligned)))), makeNorm(PETH_probeStm_aligned),'r'); hold on;
    plot((XValues_PETH_probeConcat_aligned+meanBoutStartLatency_probeConcat*10/1000)*(mean(noNans(tbtPkValues_probe_aligned))/mean(noNans(tbtPkValues_probeConcat_aligned))), makeNorm(PETH_probeConcat_aligned), 'Color',rgb('royalblue'));
    plotPETHStimPatch(relStimTimesOn_probe, relStimTimesOff_probe, boutStartTimes_probeStm, meanBoutStartLatency_probeStm);
    xlim([0 100]); thirtyLine; hold on;
    set(gca,'xtick',[30]);
    set(gca,'xticklabel',['Norm tbt peak time']);
    title('Normalized Aligned No stim/Stim/Concat stim Overlay');
    
    spaceplots([.01 .01 .01 .01], [.01 .01]);
    if wantNoPP==0
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype ', PROBE TRIALS']});
    else
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype  ', PROBE TRIALS, No Probe-Probe']});
    end
    set(superTitle,'fontsize',11);
    
    mainPlot_probe_align_noCut = figure('position', [ 1167         248         541         685]);
    subplot(4,3,1)
    plotRaster2(stackedPressMatrices_probe_aligned_noCut,corrShiftVal_noCut_probe,'k'); xlim([0 100]);
    title('No stim');
    subplot(4,3,2)
    plotRaster2(stackedPressMatrices_probeStm_aligned_noCut,corrShiftVal_noCut_probeStm,'r');  xlim([0 100]); hold on;
    findStimPatches(probeTrialExtensionTimes_stim, probeTrialRetractTimes_stim, stimTimesOn_probe, stimTimesOff_probe, boutStartTimes_probeStm); hold on;
    title('Stim');
    subplot(4,3,3)
    plotRaster2(stackedPressMatrices_probeConcat_aligned_noCut,corrShiftVal_noCut_probeConcat,rgb('royalblue'));  xlim([0 100]);
    title('Concat stim');
    subplot(4,3,4)
    plot(XValues_PETH_probe_aligned_noCut+corrShiftVal_noCut_probe*10/1000, PETH_probe_aligned_noCut,'k'); xlim([0 100]); thirtyLine; hold on;
    subplot(4,3,5)
    plot(XValues_PETH_probeStm_aligned_noCut+corrShiftVal_noCut_probeStm*10/1000, PETH_probeStm_aligned_noCut,'r'); xlim([0 100]); thirtyLine; hold on;
    subplot(4,3,6)
    plot(XValues_PETH_probeConcat_aligned_noCut+corrShiftVal_noCut_probeConcat*10/1000, PETH_probeConcat_aligned_noCut,'Color',rgb('royalblue')); xlim([0 100]); thirtyLine; hold on;
    set(mainPlot_probe_align_noCut,'defaultLineLineWidth',2);
    subplot(4,3,7:9)
    plot(XValues_PETH_probe_aligned_noCut+corrShiftVal_noCut_probe*10/1000, PETH_probe_aligned_noCut,'k'); hold on;
    plot(XValues_PETH_probeStm_aligned_noCut+corrShiftVal_noCut_probeStm*10/1000, PETH_probeStm_aligned_noCut,'r'); hold on;
    plot(XValues_PETH_probeConcat_aligned_noCut+corrShiftVal_noCut_probeConcat*10/1000, PETH_probeConcat_aligned_noCut,'Color',rgb('royalblue')); xlim([0 100]); thirtyLine; hold on;
    title('Bout Aligned + Individual Mean Latency Correction');
    subplot(4,3,10:12)
    plot(XValues_PETH_probe_aligned_noCut+(corrShiftVal_noCut_probe)*10/1000, PETH_probe_aligned_noCut,'k'); hold on;
    plot(XValues_PETH_probeStm_aligned_noCut+(corrShiftVal_noCut_probeStm-meanBoutStartLatency_probeStm+meanBoutStartLatency_probe)*10/1000, PETH_probeStm_aligned_noCut,'r'); hold on;
    plot(XValues_PETH_probeConcat_aligned_noCut+(corrShiftVal_noCut_probeConcat-meanBoutStartLatency_probeConcat+meanBoutStartLatency_probe)*10/1000, PETH_probeConcat_aligned_noCut,'Color',rgb('royalblue')); xlim([0 100]); thirtyLine; hold on;
    title('Bout Aligned + Latency Matched To Mean Latency of No Stim trials');
    spaceplots([.01 .01 .01 .01], [.01 .01]);
    if wantNoPP==0
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype ', PROBE TRIALS' ', BoutAligned-noCut']});
    else
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype  ', PROBE TRIALS, No Probe-Probe' ', BoutAligned-noCut']});
    end
    set(superTitle,'fontsize',11);
    
end