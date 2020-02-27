% Written by Patrick Strassmann

function [postStimPressLats_probe, postStimPressLats_probeStm, postStimSeqDurations_probe, postStimSeqDurations_probeStm, seqAlignedFig] = seqAligner(eventMatrixStack_probe, stackedBoutMatrices_probe,...
    eventMatrixStack_probeStm, stackedBoutMatrices_probeStm,...
    boutStartTimes_probe, boutEndTimes_probe, boutStartTimes_probeStm, boutEndTimes_probeStm,...
    relStimTimesOn_probe, relStimTimesOff_probe, stimDuration, slidingWindowSize, alpha, trialTimeLimit_probe,wantPlots, wantNoPP, genotype, subjectNumber,experimentName, startDate)

eventTimesStack_probe = makeTimesStack(eventMatrixStack_probe);
stackedBoutTimes_probe = makeTimesStack(stackedBoutMatrices_probe);
eventTimesStack_probeStm = makeTimesStack(eventMatrixStack_probeStm);
stackedBoutTimes_probeStm = makeTimesStack(stackedBoutMatrices_probeStm);
stimDuration = stimDuration*100;

stimTimeRelBoutStart = mean(relStimTimesOn_probe(~isnan(boutStartTimes_probeStm))-noNans(boutStartTimes_probeStm));

if isempty(relStimTimesOff_probe)==0 && numel(unique(relStimTimesOff_probe))==1 %If latency stimulation (or stimulation always occcurs at the same time relative to lever extension)
    relStimTimesOff_fakeForNoStm = zeros(1,size(eventTimesStack_probe,1)); %then, set the fake stimulation end time to lever extension
    relStimTimesOn_fakeForNoStm(1:size(eventTimesStack_probe,1)) = relStimTimesOn_probe(1); %then, set the fake stimulation end time to lever extension
    relStimTimesOff_wouldBeAfterStim_fakeForNoStm(1:size(eventTimesStack_probe,1))= relStimTimesOff_probe(1);
    
elseif isequal(eventTimesStack_probeStm(:,1)',relStimTimesOn_probe)==1 % If first press stim (the first presses for all trials are equal to the stim time rel to lever extension)
    relStimTimesOff_fakeForNoStm = eventTimesStack_probe(:,1); % then, set the fake stimulation end time to the first press of all trials
    relStimTimesOff_fakeForNoStm(relStimTimesOff_fakeForNoStm>trialTimeLimit_probe)=nan;
    
    relStimTimesOff_wouldBeAfterStim_fakeForNoStm = eventTimesStack_probe(:,1)+stimDuration; % then, set the fake stimulation end time to the first press+stimDuration of all trials
    relStimTimesOff_wouldBeAfterStim_fakeForNoStm(relStimTimesOff_wouldBeAfterStim_fakeForNoStm>trialTimeLimit_probe)=nan;
    relStimTimesOn_fakeForNoStm = eventTimesStack_probe(:,1);
else
    relStimTimesOff_fakeForNoStm = boutStartTimes_probe+stimTimeRelBoutStart; %If stimulating in the middle of the bout, set the fake stimulation end time to the start of where stimulation would begin relative to the start of the bout
    relStimTimesOff_fakeForNoStm(relStimTimesOff_fakeForNoStm>trialTimeLimit_probe)=nan;
    relStimTimesOff_wouldBeAfterStim_fakeForNoStm = boutStartTimes_probe+stimTimeRelBoutStart + stimDuration;
    relStimTimesOff_wouldBeAfterStim_fakeForNoStm(relStimTimesOff_wouldBeAfterStim_fakeForNoStm>trialTimeLimit_probe)=nan;
    
    relStimTimesOn_fakeForNoStm = boutStartTimes_probe + stimTimeRelBoutStart; %
end

[postStimSeqMatrix_probe,postStimSeqTimes_probe, postStimPressLats_probe, postStimSeqDurations_probe, shiftedBoutEndTimes_probe] = postStimAccel(eventMatrixStack_probe,relStimTimesOn_fakeForNoStm, relStimTimesOff_fakeForNoStm, boutEndTimes_probe, trialTimeLimit_probe);
[postStimSeqMatrix_probeStm,postStimSeqTimes_probeStm, postStimPressLats_probeStm, postStimSeqDurations_probeStm, shiftedBoutEndTimes_probeStm, postStimSeqMatrix_probeStm_wStimDur, postStimSeqTimes_probeStm_wStimDur, shiftedBoutEndTimes_probeStm_wStimDur] = postStimAccel(eventMatrixStack_probeStm,relStimTimesOn_probe, relStimTimesOff_probe, boutEndTimes_probeStm, trialTimeLimit_probe);
[postStimSeqMatrix_probe_wouldBe,postStimSeqTimes_probe_wouldBe, postStimPressLats_probe_wouldBe, postStimSeqDurations_probe_wouldBe, shiftedBoutEndTimes_probe_wouldBe] = postStimAccel(eventMatrixStack_probe,relStimTimesOn_fakeForNoStm, relStimTimesOff_wouldBeAfterStim_fakeForNoStm, boutEndTimes_probe, trialTimeLimit_probe);

[xval_postStimAl_probe, peth_postStimAl_probe] = makeSmoothedPETH(postStimSeqMatrix_probe, slidingWindowSize, alpha, 1, 1);
[xval_postStimWouldBe_probe, peth_postStimWouldBe_probe] = makeSmoothedPETH(postStimSeqMatrix_probe_wouldBe, slidingWindowSize, alpha, 1, 1);
[xval_postStimAl_probeStm, peth_postStimAl_probeStm] = makeSmoothedPETH(postStimSeqMatrix_probeStm, slidingWindowSize, alpha, 1, 1);
[xval_stimStartAl_probeStm, peth_stimStartAl_probeStm] = makeSmoothedPETH(postStimSeqMatrix_probeStm_wStimDur, slidingWindowSize, alpha, 1, 1);

meanPostStimPressLatency_probe = mean(noNans(postStimPressLats_probe));
meanPostStimPressLatency_probeStm = mean(noNans(postStimPressLats_probeStm));
meanPostStimPressDurations_probe = mean(noNans(postStimSeqDurations_probe));
meanPostStimPressDurations_probeStm = mean(noNans(postStimSeqDurations_probeStm));
meanPostStimNumPresses_probe = mean(sum(postStimSeqTimes_probe>0,2));
meanPostStimNumPresses_probeStm = mean(sum(postStimSeqTimes_probeStm>0,2));


cvPostStimPressLatency_probe = cv(postStimPressLats_probe);
cvPostStimPressLatency_probeStm = cv(postStimPressLats_probeStm);
cvPostStimPressDurations_probe = cv(postStimSeqDurations_probe);
cvPostStimPressDurations_probeStm = cv(postStimSeqDurations_probeStm);
cvPostStimNumPresses_probe = cv(sum(postStimSeqTimes_probe>0,2));
cvPostStimNumPresses_probeStm = cv(sum(postStimSeqTimes_probeStm>0,2));

meanAndCVMat = [[meanPostStimPressLatency_probe meanPostStimPressLatency_probeStm meanPostStimPressDurations_probe meanPostStimPressDurations_probeStm meanPostStimNumPresses_probe meanPostStimNumPresses_probeStm];...
    [cvPostStimPressLatency_probe cvPostStimPressLatency_probeStm cvPostStimPressDurations_probe cvPostStimPressDurations_probeStm cvPostStimNumPresses_probe cvPostStimNumPresses_probeStm]];

[h_s2Lat p_s2Lat] = ttest2(postStimPressLats_probe,postStimPressLats_probeStm);
[h_s2Dur p_s2Dur] = ttest2(postStimSeqDurations_probe,postStimSeqDurations_probeStm);
[h_s2PostStimNumPresses p_s2PostStimNumPresses] = ttest2(sum(postStimSeqTimes_probe>0,2),sum(postStimSeqTimes_probeStm>0,2));

sigMat_s2 = [[h_s2Lat p_s2Lat]; [h_s2Dur p_s2Dur]; [h_s2PostStimNumPresses p_s2PostStimNumPresses]];

if wantPlots==1
    seqAlignedFig = figure('position',[1370         136         511         828]);
    subplot(6,2,1)
    plotJRaster(postStimSeqMatrix_probe,'k'); hold on;
    title('No stim S2');
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probe)),shiftedBoutEndTimes_probe);
    xlim([0 100]);
    subplot(6,2,2)
    plotJRaster(postStimSeqMatrix_probeStm,'r'); hold on;
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probeStm)),shiftedBoutEndTimes_probeStm);
    title('Stim S2');
    subplot(6,2,3:4)
    plot(xval_postStimAl_probe,peth_postStimAl_probe,'k','linewidth',2); xlim([0 100]); set(gca,'xtick',[]); hold on;
    plot(xval_postStimAl_probeStm,peth_postStimAl_probeStm,'r','linewidth',2); hold on;
    plotS2Labels(meanAndCVMat,sigMat_s2)
    title('Aligned S2');
    subplot(6,2,5)
    plotJRaster(postStimSeqMatrix_probe,'k');hold on;
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probe)),shiftedBoutEndTimes_probe);
    xlim([0 100]);
    subplot(6,2,6)
    plotJRaster(postStimSeqMatrix_probeStm_wStimDur,'r'); hold on;
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probeStm_wStimDur)),shiftedBoutEndTimes_probeStm_wStimDur);
    xlim([0 100]);
    subplot(6,2,7:8)
    plot(xval_postStimAl_probe,peth_postStimAl_probe,'k','linewidth',2); set(gca,'xtick',[]); hold on;
    plot(xval_stimStartAl_probeStm,peth_stimStartAl_probeStm,'r','linewidth',2)
    title('No stim S2 aligned with stimTimeOn of stim');
    subplot(6,2,9)
    plotJRaster(postStimSeqMatrix_probe_wouldBe,'k'); hold on;
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probe_wouldBe)),shiftedBoutEndTimes_probe_wouldBe);
    xlim([0 100]);
    subplot(6,2,10)
    plotJRaster(postStimSeqMatrix_probeStm,'r'); hold on;
    markBoutBounderies(nan(1,numel(shiftedBoutEndTimes_probeStm)),shiftedBoutEndTimes_probeStm);
    xlim([0 100]);
    subplot(6,2,11:12)
    plot(xval_postStimWouldBe_probe,peth_postStimWouldBe_probe,'k','linewidth',2); set(gca,'xtick',[]); hold on;
    plot(xval_postStimAl_probeStm,peth_postStimAl_probeStm,'r','linewidth',2);
    title('Would-be stimTimeOff of No stim aligned with S2 of stim');
    spaceplots;
    stimDuration = stimDuration/100;

    if wantNoPP==0
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype ', PROBE TRIALS' ', S2 Analysis']});
    else
        superTitle = suptitle({[startDate(4:end) ' ' experimentName ', stimDur=' num2str(stimDuration, '%.3f') 's'],['Subj' subjectNumber ', ' genotype  ', PROBE TRIALS, No Probe-Probe' ', S2 Analysis']});
    end
    set(superTitle,'fontsize',11);
else
    seqAlignedFig = 0;
end
end


