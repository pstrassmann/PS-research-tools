%Written by Patrick Strassmann

function [statsMat] = plotStats(eventStartLatencyMatrices, eventDurationMatrices, stackedBoutIPIs, Colors, legendNames,tossUnengagedTrials,eventMatricesStack)
if nargin>5
    if tossUnengagedTrials==1
        for i=1:numel(eventMatricesStack)
            eventMatrixStack = eventMatricesStack{i};
            eventStartLatencyMatrix = eventStartLatencyMatrices{i};
            eventDurationMatrix = eventDurationMatrices{i};
            oneStackedBoutIPIs = stackedBoutIPIs{i};
            unengagedTrials = sum(eventMatrixStack,2)<10;
            eventStartLatencyMatrix(unengagedTrials)=nan;
            eventDurationMatrix(unengagedTrials)=nan;
            eventStartLatencyMatrices{i} = eventStartLatencyMatrix;
            eventDurationMatrices{i} = eventDurationMatrix;
            oneStackedBoutIPIs(unengagedTrials,:) = nan;
            stackedBoutIPIs{i} = oneStackedBoutIPIs;
        end
    end
end
legFontSize = 8;
numEntries = size(eventStartLatencyMatrices,2);
statsMat = nan(numEntries,8);

subplot(3,4,1)

for i=1:numEntries
    plot(1:numel(eventStartLatencyMatrices{i}),eventStartLatencyMatrices{i}*10/1000,'ko','MarkerFaceColor',Colors{i});
    hold on;
end
ylabel('Latency (s)'); xlabel('Trial #'); leg = legend(legendNames); set(leg,'fontsize',legFontSize); ylimit = ylim;
subplot(3,4,2)

legEntries = {};
for i=1:numEntries
    nonNansLatencyMatrix = eventStartLatencyMatrices{i}(~isnan(eventStartLatencyMatrices{i}));
    statsMat(i,1) = mean(nonNansLatencyMatrix);
    statsMat(i,2) = std(nonNansLatencyMatrix);
    legEntries{i} = [legendNames{i} ' ' num2str(mean(nonNansLatencyMatrix)*10/1000,'%.1f') 's'];
    bar(i,mean(nonNansLatencyMatrix)*10/1000,'facecolor',Colors{i}); hold on;
    hold on;
end
set(gca,'xticklabel',[]);
leg = legend(legEntries);  set(leg,'fontsize',legFontSize);
ylim(ylimit);
for i=1:numEntries
    nonNansLatencyMatrix = eventStartLatencyMatrices{i}(~isnan(eventStartLatencyMatrices{i}));
    line([i i], [mean(nonNansLatencyMatrix)*10/1000 + sem(nonNansLatencyMatrix*10/1000) mean(nonNansLatencyMatrix)*10/1000 - sem(nonNansLatencyMatrix*10/1000)], 'Color','k');
    hold on;
end
subplot(3,4,3)
x = [];
g = [];
for i=1:numEntries
    x = [x; (eventStartLatencyMatrices{i}*10/1000)'];
    g = [g; i*ones(size(eventStartLatencyMatrices{i}'))];
end
boxplot(x,g,'labels',legendNames);
ylim(ylimit);

subplot(3,4,4)
legEntries = {};
for i=1:numEntries
    nonNansLatencyMatrix = eventStartLatencyMatrices{i}(~isnan(eventStartLatencyMatrices{i}));
    legEntries{i} = [legendNames{i} ' ' num2str(std(nonNansLatencyMatrix)/mean(nonNansLatencyMatrix),'%.4f')];
    bar(i,std(nonNansLatencyMatrix)/mean(nonNansLatencyMatrix),'facecolor',Colors{i}); hold on;
    hold on;
end
set(gca,'xticklabel',[]); leg = legend(legEntries,'location','Southwest');  set(leg,'fontsize',legFontSize); %ylim([0 1]);
title('CV');
%%
subplot(3,4,5)
for i=1:numEntries
    plot(1:numel(eventDurationMatrices{i}),eventDurationMatrices{i}*10/1000,'ko','MarkerFaceColor',Colors{i});
    hold on;
end
ylabel('Bout Duration (s)'); xlabel('Trial #'); leg = legend(legendNames); set(leg,'fontsize',legFontSize); ylimit = ylim;
subplot(3,4,6)
legEntries = {};
for i=1:numEntries
    nonNansDurationMatrix = eventDurationMatrices{i}(~isnan(eventDurationMatrices{i}));
    statsMat(i,7) = mean(nonNansDurationMatrix);
    statsMat(i,8) = std(nonNansDurationMatrix);
    legEntries{i} = [legendNames{i} ' ' num2str(mean(nonNansDurationMatrix)*10/1000,'%.1f') 's'];
    bar(i,mean(nonNansDurationMatrix)*10/1000,'facecolor',Colors{i}); hold on;
    hold on;
end
set(gca,'xticklabel',[]);
leg = legend(legEntries); set(leg,'fontsize',legFontSize);
ylim(ylimit);
for i=1:numEntries
    nonNansDurationMatrix = eventDurationMatrices{i}(~isnan(eventDurationMatrices{i}));
    line([i i], [mean(nonNansDurationMatrix)*10/1000 + sem(nonNansDurationMatrix*10/1000) mean(nonNansDurationMatrix)*10/1000 - sem(nonNansDurationMatrix*10/1000)],'Color','k');
    hold on;
end
ylim(ylimit)
subplot(3,4,7)
x = [];
g = [];
for i=1:numEntries
    x = [x; (eventDurationMatrices{i}*10/1000)'];
    g = [g; i*ones(size(eventDurationMatrices{i}'))];
end
boxplot(x,g,'labels',legendNames); ylim(ylimit)

subplot(3,4,8)
legEntries = {};
for i=1:numEntries
    nonNansDurationMatrix = eventDurationMatrices{i}(~isnan(eventDurationMatrices{i}));
    legEntries{i} = [legendNames{i} ' ' num2str(std(nonNansDurationMatrix)/mean(nonNansDurationMatrix),'%.4f')];
    bar(i,std(nonNansDurationMatrix)/mean(nonNansDurationMatrix),'facecolor',Colors{i}); hold on;
    hold on;
end
set(gca,'xticklabel',[]); leg = legend(legEntries,'location','Southwest');  set(leg,'fontsize',legFontSize);% ylim([0 1]);

subplot(3,4,9)
for i=1:numEntries
    legendz{i} = plot(5,5,'ko','MarkerFaceColor',Colors{i}); hold on;
end
leg = legend(legendNames); set(leg,'fontsize',legFontSize);
for i=1:numEntries
    delete(legendz{i});
end
for i=1:numEntries
    [meanIPIsVect, semIPIsVect] = tbtMeansAndErrorsFromStack(stackedBoutIPIs{i});
    for j=1:numel(meanIPIsVect)
        plot(j,meanIPIsVect(j)*10/1000,'ko','MarkerFaceColor',Colors{i}); hold on;
    end
end

ylabel('IPI (s)'); xlabel('Trial #'); ylimit = ylim;

for i=1:numEntries
    [meanIPIsVect, semIPIsVect] = tbtMeansAndErrorsFromStack(stackedBoutIPIs{i});
    for j=1:numel(meanIPIsVect)
        line([j j], [meanIPIsVect(j)*10/1000+semIPIsVect(j)*10/1000 meanIPIsVect(j)*10/1000-semIPIsVect(j)*10/1000],'Color','k');
    end
end
ylim(ylimit);
subplot(3,4,10)
legEntries = {};
for i=1:numEntries
    [meanIPI, semIPI, stdIPI] = meanIPIfromStack(stackedBoutIPIs{i});
    statsMat(i,5) = meanIPI*10/1000;
    statsMat(i,6) = stdIPI*10/1000;
    legEntries{i} = [legendNames{i} ' ' num2str(meanIPI*10/1000,'%.3f') 's'];
    bar(i,meanIPI*10/1000,'facecolor',Colors{i}); hold on;
    hold on;
end
ylim([0 1]);
set(gca,'xticklabel',[]);
leg = legend(legEntries); set(leg,'fontsize',legFontSize);
for i =1:numEntries
    [meanIPI, semIPI] = meanIPIfromStack(stackedBoutIPIs{i});
    line([i i], [meanIPI*10/1000 + semIPI*10/1000 meanIPI*10/1000 - semIPI*10/1000], 'Color','k');
end
ylim(ylimit);

subplot(3,4,11)
x = [];
g = [];
for i=1:numEntries
    [meanIPI, semIPI,stdIPI, IPIvect] = meanIPIfromStack(stackedBoutIPIs{i});
    IPIvect = IPIvect';
    x = [x; (IPIvect*10/1000)'];
    g = [g; i*ones(size(IPIvect'))];
end
boxplot(x,g,'labels',legendNames);

subplot(3,4,12)
legEntries = {};
for i=1:numEntries
    [meanIPI, semIPI, stdIPI] = meanIPIfromStack(stackedBoutIPIs{i});
    legEntries{i} = [legendNames{i} ' ' num2str(stdIPI/meanIPI,'%.4f') 's'];
    bar(i,stdIPI/meanIPI,'facecolor',Colors{i}); hold on;
    hold on;
end
set(gca,'xticklabel',[]); leg = legend(legEntries,'location','Southwest'); set(leg,'fontsize',legFontSize);
