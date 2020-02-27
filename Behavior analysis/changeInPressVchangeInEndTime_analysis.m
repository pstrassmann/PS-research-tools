% Written by Patrick Strassmann
% pct change in # presses during stim VERSUS pct change in end time

rawCh_withinStim_D1 = extractedStimData_FS_azd.rawChangeWithinStim_ElXEl(1:7,1:7);
rawCh_withinStim_D2 = extractedStimData_FS_azd.rawChangeWithinStim_ElXEl(8:end,1:7);
rawCh_withinStim_GRN = extractedStimData_FS_GRN_azd.rawChangeWithinStim_ElXEl;

rawCh_withinStim_D1_mean = mean(rawCh_withinStim_D1);
rawCh_withinStim_D2_mean = mean(rawCh_withinStim_D2);

pctCh_withinStim_D1 = extractedStimData_FS_azd.pctChangeWithinStim_ElXEl(1:7,1:7);
pctCh_withinStim_D2 = extractedStimData_FS_azd.pctChangeWithinStim_ElXEl(8:end,1:7);
pctCh_withinStim_GRN = extractedStimData_FS_GRN_azd.pctChangeWithinStim_ElXEl;

pctCh_withinStim_D1_mean = mean(pctCh_withinStim_D1);
pctCh_withinStim_D2_mean = mean(pctCh_withinStim_D2);
pctCh_withinStim_GRN_mean = mean(pctCh_withinStim_GRN);

[pctCh_stopTime_D1, rawCh_stopTime_D1] = pctChangeFromMeanMatrix(extractedStimData_FS_azd.meanBoutEndTimes(1:7,1:8));
[pctCh_stopTime_D2, rawCh_stopTime_D2] = pctChangeFromMeanMatrix(extractedStimData_FS_azd.meanBoutEndTimes(8:end,1:8));
[pctCh_stopTime_GRN, rawCh_stopTime_GRN] = pctChangeFromMeanMatrix(extractedStimData_FS_GRN_azd.meanBoutEndTimes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% D1 %%%%
rawCh_withinStim_D1_1to5 = rawCh_withinStim_D1(:,1:5);
rawCh_withinStim_D1_shortEarlylongEarly  = rawCh_withinStim_D1(:,[2 6]);
rawCh_withinStim_D1_shortLatelongLate  = rawCh_withinStim_D1(:,[4 7]);
rawCh_withinStim_D1_longEarlylongLate  = rawCh_withinStim_D1(:,[6 7]);

pctCh_withinStim_D1_1to5 = pctCh_withinStim_D1(:,1:5);
pctCh_withinStim_D1_shortEarlylongEarly  = pctCh_withinStim_D1(:,[2 6]);
pctCh_withinStim_D1_shortLatelongLate  = pctCh_withinStim_D1(:,[4 7]);
pctCh_withinStim_D1_longEarlylongLate  = pctCh_withinStim_D1(:,[6 7]);

rawCh_stopTime_D1_1to5 = rawCh_stopTime_D1(:,1:5);
rawCh_stopTime_D1_shortEarlylongEarly  = rawCh_stopTime_D1(:,[2 6]);
rawCh_stopTime_D1_shortLatelongLate  = rawCh_stopTime_D1(:,[4 7]);
rawCh_stopTime_D1_longEarlylongLate  = rawCh_stopTime_D1(:,[6 7]);

pctCh_stopTime_D1_1to5 = pctCh_stopTime_D1(:,1:5);
pctCh_stopTime_D1_shortEarlylongEarly  = pctCh_stopTime_D1(:,[2 6]);
pctCh_stopTime_D1_shortLatelongLate  = pctCh_stopTime_D1(:,[4 7]);
pctCh_stopTime_D1_longEarlylongLate  = pctCh_stopTime_D1(:,[6 7]);

figure; plot(rawCh_withinStim_D1_1to5(:),pctCh_stopTime_D1_1to5(:),'o');
figure; plot(rawCh_withinStim_D1_1to5(:),rawCh_stopTime_D1_1to5(:),'o');
figure; plot(pctCh_withinStim_D1_1to5(:),pctCh_stopTime_D1_1to5(:),'o');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% D2 %%%%%
rawCh_withinStim_D2_1to5 = rawCh_withinStim_D2(:,1:5);
rawCh_withinStim_D2_shortEarlylongEarly  = rawCh_withinStim_D2(:,[2 6]);
rawCh_withinStim_D2_shortLatelongLate  = rawCh_withinStim_D2(:,[4 7]);
rawCh_withinStim_D2_longEarlylongLate  = rawCh_withinStim_D2(:,[6 7]);

pctCh_withinStim_D2_1to5 = pctCh_withinStim_D2(:,1:5);
pctCh_withinStim_D2_shortEarlylongEarly  = pctCh_withinStim_D2(:,[2 6]);
pctCh_withinStim_D2_shortLatelongLate  = pctCh_withinStim_D2(:,[4 7]);
pctCh_withinStim_D2_longEarlylongLate  = pctCh_withinStim_D2(:,[6 7]);

rawCh_stopTime_D2_1to5 = rawCh_stopTime_D2(:,1:5);
rawCh_stopTime_D2_shortEarlylongEarly  = rawCh_stopTime_D2(:,[2 6]);
rawCh_stopTime_D2_shortLatelongLate  = rawCh_stopTime_D2(:,[4 7]);
rawCh_stopTime_D2_longEarlylongLate  = rawCh_stopTime_D2(:,[6 7]);

pctCh_stopTime_D2_1to5 = pctCh_stopTime_D2(:,1:5);
pctCh_stopTime_D2_shortEarlylongEarly  = pctCh_stopTime_D2(:,[2 6]);
pctCh_stopTime_D2_shortLatelongLate  = pctCh_stopTime_D2(:,[4 7]);
pctCh_stopTime_D2_longEarlylongLate  = pctCh_stopTime_D2(:,[6 7]);

figure; plot(rawCh_withinStim_D2_1to5(:),pctCh_stopTime_D2_1to5(:),'o');
figure; plot(rawCh_withinStim_D2_1to5(:),rawCh_stopTime_D2_1to5(:),'o');
figure; plot(pctCh_withinStim_D2_1to5(:),pctCh_stopTime_D2_1to5(:),'o');

rawCh_withinStim_D1_1 = rawCh_withinStim_D1_1to5(:,1);
rawCh_withinStim_D1_2 = rawCh_withinStim_D1_1to5(:,2);
rawCh_withinStim_D1_3 = rawCh_withinStim_D1_1to5(:,3);
rawCh_withinStim_D1_4 = rawCh_withinStim_D1_1to5(:,4);
rawCh_withinStim_D1_5 = rawCh_withinStim_D1_1to5(:,5);

pctCh_stopTime_D1_1 = pctCh_stopTime_D1_1to5(:,1);
pctCh_stopTime_D1_2 = pctCh_stopTime_D1_1to5(:,2);
pctCh_stopTime_D1_3 = pctCh_stopTime_D1_1to5(:,3);
pctCh_stopTime_D1_4 = pctCh_stopTime_D1_1to5(:,4);
pctCh_stopTime_D1_5 = pctCh_stopTime_D1_1to5(:,5);

figure; plot(rawCh_withinStim_D1_1,pctCh_stopTime_D1_1); hold on;
plot(rawCh_withinStim_D1_2,pctCh_stopTime_D1_2,'o'); hold on;
plot(rawCh_withinStim_D1_3,pctCh_stopTime_D1_3,'o'); hold on;
plot(rawCh_withinStim_D1_4,pctCh_stopTime_D1_4,'o'); hold on;
plot(rawCh_withinStim_D1_5,pctCh_stopTime_D1_5,'o');

rawCh_withinStim_D1_cell_1to5 = {rawCh_withinStim_D1_1, rawCh_withinStim_D1_2,...
    rawCh_withinStim_D1_3, rawCh_withinStim_D1_4, rawCh_withinStim_D1_5};

pctCh_stopTime_D1_cell_1to5 = {pctCh_stopTime_D1_1, pctCh_stopTime_D1_2,...
    pctCh_stopTime_D1_3, pctCh_stopTime_D1_4, pctCh_stopTime_D1_5};

figure; plotCorr(rawCh_withinStim_D1_cell_1to5, pctCh_stopTime_D1_cell_1to5);