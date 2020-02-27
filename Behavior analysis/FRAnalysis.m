% Written by Patrick Strassmann
% Analysis for Fixed-ratio behavioral task
slidingWindowSize = 19;
sigma = slidingWindowSize
alpha = slidingWindowSize/(2*sigma);
IPIcriterion = 20
collectData = 1
amplitudeAnalysis = 1;
burstCountsToAnalyze = 1:6;
plotSpikesAndPETHsSeparately = 1;
FR = 4;

signalStruct = struct;
varNames = who;
a = cellfun(@(x) strfind(x,'sig0'), varNames,'uniformoutput',0);
validInds = ~cellfun(@isempty,a);
validVarNames = varNames(validInds);
b = cellfun(@(x) strfind(x,'_'), validVarNames,'uniformoutput',0);
validInds = cellfun(@isempty,b);
validVarNames = validVarNames(validInds);

if exist('leftlever','var')
    leverPresses = leftlever;
    display('Using leftlever var');
elseif exist('rightlever','var')
    leverPresses = rightlever;
    display('Using rightlever var');
else
    error('Cannot find leftlever or rightlever var');
end

IPIs = diff(leverPresses);
burstStart_leftLeverInds = find(IPIs>IPIcriterion)+1;
burstStartTimes = round(leverPresses(burstStart_leftLeverInds)*100);
burstCount = nan(1,numel(burstStart_leftLeverInds));

% Counting number of presses in a burst
for i = 1:numel(burstStart_leftLeverInds)-1
    burstCount(i) = numel(leverPresses(burstStart_leftLeverInds(i):burstStart_leftLeverInds(i+1)))-1;
end
%%%

[burstCount_sorted] = sort(burstCount);
burstCount_unique = unique(burstCount);
burstCount_uniqueCount = diff([0 find(diff(burstCount_sorted)~=0)]);
burstCount_uniqueInds = cell(max(burstCount_unique),1);

for i = noNans(burstCount_unique)
    burstCount_uniqueInds{i} = find(burstCount==i);
end

%%Find rewarded press
rewardedLeverPressInd = zeros(1,numel(reward));
for i=1:numel(reward)
    currRewardedLeverPressInd = find(round(leverPresses'*100)==round(reward(i)*100));
    if ~isempty(currRewardedLeverPressInd)
        rewardedLeverPressInd(i) = currRewardedLeverPressInd;
    end
end
rewardedLeverPressInd(isempty(rewardedLeverPressInd)) = [];

% burstStartTimes = round(leverPresses(rewardedLeverPressInd-(FR-1))*100); display('Setting burstStartTimes based on rewardDelivery');
% burstStartTimes = round(leverPresses*100); display('Setting burstStartTimes based on every lever press');
% burstStartTimes = round(leverPresses(burstStart_leftLeverInds)*100);
% nonBurstStartTimes = round(leverPresses(setdiff([1:numel(leverPresses)],burstStart_leftLeverInds))*100);
% burstStartTimes = nonBurstStartTimes; display('Setting burstStartTimes = nonBurstStartTimes');
% burstStartTimes = randi([6000,290000],1,439);


% burstLength = 9;
% indsOfBurstStartsWithCriterionNumPresses = burstCount_uniqueInds{burstLength};
% indsOfLeverPressesWhereBurstStarts = burstStart_leftLeverInds(indsOfBurstStartsWithCriterionNumPresses);
% figure; plot(leverPresses,'.'); hold on; plot(indsOfLeverPressesWhereBurstStarts,leverPresses(indsOfLeverPressesWhereBurstStarts),'mo');
figure; plot(IPIs,'.'); stdCrit = .5* std(IPIs); xlimit = xlim(); hold on; line(xlimit,[stdCrit stdCrit]);

figure('position',[529          90        1124         825]);
plot(leverPresses,'.'); hold on; plot(burstStart_leftLeverInds,leverPresses(burstStart_leftLeverInds),'mo');
% burstStartTimes = burstStartTimes(indsOfBurstStartsWithCriterionNumPresses);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






if collectData == 1
    for i = 1:numel(validVarNames)
        spikeTrain_raw = eval(validVarNames{i});
        spikeTrain = round(spikeTrain_raw'*100);
        eventMatrix_spike = zeros(1,spikeTrain(end));
        spikeTrain(spikeTrain==0)=[];
        eventMatrix_spike(spikeTrain) = 1;
        pre = 400;
        post = 400;
        spikeStack = nan(numel(burstStartTimes),pre+post+1);
        
        for j = 1:numel(burstStartTimes)
            try spikeStack(j,1:pre+post+1)=eventMatrix_spike(burstStartTimes(j)-pre:burstStartTimes(j)+post);
            catch
                continue; display('Stacking failed');
            end
        end
        
        
        [XValues_spike, PETH_spike] = makeSmoothedPETH(spikeStack, slidingWindowSize, alpha, 0);
        XValues_spike = XValues_spike-pre/100;
        signalName = validVarNames{i};
        signalStruct.(signalName).spikeStack = spikeStack;
        signalStruct.(signalName).XValues_spike = XValues_spike;
        signalStruct.(signalName).PETH_spike = PETH_spike;
        signalStruct.prePost = [pre post];
        
        spikeStack_burstCount_cell = cell(1,numel(max(burstCountsToAnalyze)));
        for numPressesInBurst = burstCountsToAnalyze
            spikeStack_burstCount_cell{numPressesInBurst} = spikeStack(burstCount_uniqueInds{numPressesInBurst},1:end);
        end
        
        
        for numPressesInBurst = burstCountsToAnalyze;
            spikeStack = spikeStack_burstCount_cell{numPressesInBurst};
            [XValues_spike, PETH_spike] = makeSmoothedPETH(spikeStack, slidingWindowSize, alpha, 0);
            XValues_spike = XValues_spike-pre/100;
            signalName = validVarNames{i};
            signalStruct.(signalName).(['spikeStack_' num2str(numPressesInBurst)]) = spikeStack;
            signalStruct.(signalName).(['XValues_spike_' num2str(numPressesInBurst)]) = XValues_spike;
            signalStruct.(signalName).(['PETH_spike_' num2str(numPressesInBurst)]) = PETH_spike;
        end
    end
    
    sq = sqrt(numel(validVarNames));
    if sq-fix(sq)>0.5
        spX = ceil(sq);
        spY = ceil(sq);
    else
        spX = ceil(sq);
        spY = fix(sq);
    end
    
    if plotSpikesAndPETHsSeparately == 1
        figure('position',[1     1   960   973]);
        for i = 1:numel(validVarNames)
            currSig = validVarNames{i};
            subplot(spX,spY,i)
            plot(signalStruct.(currSig).XValues_spike, signalStruct.(currSig).PETH_spike); %title(validVarNames{i});
%             set(gca,'ButtonDownFcn',@expand_subplot)
            axis tight; drawnow;
        end
%         spaceplots
        
        figure('position',[961     1   960   973]);
        for i = 1:numel(validVarNames)
            currSig = validVarNames{i};
            subplot(spX,spY,i)
            plotRaster2(signalStruct.(currSig).spikeStack,-pre,'k'); title(validVarNames{i});
            set(gca,'ButtonDownFcn',@expand_subplot)
            axis tight; drawnow;
        end
%         spaceplots
    end
    
    sq = sqrt(numel(validVarNames)*2);
    if sq-fix(sq)>0.5
        spX = ceil(sq);
        spY = ceil(sq);
    else
        spX = ceil(sq);
        spY = fix(sq);
    end
    
    if spY>spX
        subInds = reshape([1:spX*(spY)],spX,spY)';
    else
        subInds = reshape([1:spY*(spX)],spY,spX)';
    end
    
    subInds(2:2:spX,:) = [];
    subInds = subInds';
    subInds = subInds(:)';
    figure('position',[21           1        1876         973]);
    %  subInds = [1:2:numel(validVarNames)*2];
    if plotSpikesAndPETHsSeparately == 0
    for i = 1:numel(validVarNames)
        currSig = validVarNames{i};
        subplot(spX+1,spY,subInds(i))
        plotRaster2(signalStruct.(currSig).spikeStack,-pre,'k'); tit = title(validVarNames{i});
        set(tit,'ButtonDownFcn',@expand_subplot)
        axis tight;
        subplot(spX+1,spY,subInds(i)+spY)
        plot(signalStruct.(currSig).XValues_spike, signalStruct.(currSig).PETH_spike); tit = title(validVarNames{i});
        set(gca,'ButtonDownFcn',@expand_subplot)
        axis tight; drawnow;
    end
    end
%     spaceplots
end

%%
if amplitudeAnalysis ==1
    figure;
    unit = 'sig002a';
    maxYlim = 0;
    for numPressesInBurst = burstCountsToAnalyze
        XValues = signalStruct.(unit).(['XValues_spike_' num2str(numPressesInBurst)]);
        PETH = signalStruct.(unit).(['PETH_spike_' num2str(numPressesInBurst)]);
        subplot(2,max(burstCountsToAnalyze),numPressesInBurst)
        plotRaster2(signalStruct.(unit).(['spikeStack_' num2str(numPressesInBurst)]),-pre,'k');
        title(['numBursts =' num2str(burstCount_uniqueCount(numPressesInBurst))]);
        subplot(2,max(burstCountsToAnalyze),numPressesInBurst+max(burstCountsToAnalyze))
        plot(XValues, PETH);
        ylimit = ylim;
        if ylimit(2)>maxYlim
            maxYlim = ylimit(2);
        end
    end
    for numPressesInBurst = burstCountsToAnalyze;
        subplot(2,max(burstCountsToAnalyze),numPressesInBurst+max(burstCountsToAnalyze))
        ylimit = ylim;
        ylim([ylimit(1) maxYlim]);
    end
    spaceplots;
end






% spikeTrain = round(sig002b'*100);
% eventMatrix_spike = zeros(1,spikeTrain(end));
% eventMatrix_spike(spikeTrain) = 1;
%
% [XValues_spike, PETH_spike] = makeSmoothedPETH(eventMatrix_spike, slidingWindowSize, alpha, 0);
% figure; plot(XValues_spike, PETH_spike);

% figure; plotRaster2(leverPresses'*100,0','k'); hold on; plot(leverPresses(burstStartInds(26)),1,'mo');

% plot(leverPresses(burstStartInds),ones(1,numel(burstStartInds)),'mo')
% end