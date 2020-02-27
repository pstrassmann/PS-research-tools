% Written by Patrick Strassmann
% Graphical representation of different potential outcomes on timing
% behavior following stimulatin--induced press inhibition
stimCondStarts = [50, 950, 1850, 2750, 3650, 7250, 50, 1850, 50, 1850]/100;
stimCondDurs = [500, 500, 500, 500, 500, 500, 1400, 1400, 1400, 1400]/100;
stimEndTimes = (stimCondStarts+stimCondDurs);
controlStartTime = 3;
controlEndTime = 47;
adj = 1.8;
e = 1;
wantSave = 0;
skipSingleFigs =1;

stopTimes_mat = [[controlEndTime controlEndTime controlEndTime controlEndTime controlEndTime];
    [controlEndTime+stimCondDurs(1:5)];
    [stimEndTimes(1:5)+controlEndTime];
    [controlEndTime+0 controlEndTime+15*e controlEndTime+30*e controlEndTime+45*e controlEndTime+60*e];
    [controlEndTime+0 controlEndTime+5*e controlEndTime+10*e controlEndTime+15*e controlEndTime+20*e];
    ]
titleList = ({'Perfect compensation'; 'Pause'; 'Reset';  'Additive reset'; 'Subtractive reset';});
if skipSingleFigs == 0 ;
figure('position',[120 711 1243 239]);

for i = 1:5
    subplot(1,5,i)
    pressBlockLine(1,controlStartTime,controlEndTime,nan,nan,adj);
    for j = 1:5
        pressBlockLine(j+1,controlStartTime,stopTimes_mat(i,j),stimCondStarts(j),stimCondDurs(j),adj);
    end
    ylim([0 j+2]); xlim([0 100]);
    dottedVertLine(controlEndTime,'-',2,'r'); hold on;
    xlabel('Time (s)');
    set(gca,'YTick',[1:1:j+1]);
    set(gca,'YLimMode','manual',...    %# Freeze the current limits
        'YTickMode','manual',...   %# Freeze the current tick values
        'YTickLabel',{'NS', '3', '12','21','30','39'});
    set(gca,'XTick',[0:15:90]);
    set(gca,'fontsize',15);
    %     hold on; plot([controlEndTime stopTimes_mat(i,:)],1:6,'.-');
    %     hold on; plot([controlStartTime stimCondStarts(1:5)+5],1:6,'.-');
    title(titleList(i)); ylabel('Stimulation position (s)');
    
    pressModel = figure('position',[254   453   270   242]);
    pressBlockLine(1,controlStartTime,controlEndTime,nan,nan,adj);
    for j = 1:5
        pressBlockLine(j+1,controlStartTime,stopTimes_mat(i,j),stimCondStarts(j),stimCondDurs(j),adj);
    end
    ylim([0 j+2]); xlim([0 100]);
    dottedVertLine(controlEndTime,'-',2,'r'); hold on;
    xlabel('Time (s)');
    set(gca,'YTick',[1:1:j+1]);
    set(gca,'YLimMode','manual',...    %# Freeze the current limits
        'YTickMode','manual',...   %# Freeze the current tick values
        'YTickLabel',{'NS', '3', '12','21','30','39'});
    set(gca,'XTick',[0:15:90]);
    set(gca,'fontsize',15);
    title(titleList(i)); ylabel('Stimulation position (s)');
    
    spaceplots
    if wantSave == 1
        save2pdf(['~/Desktop/Jin Lab/Imported Data/Single Lever Ai32 Opto 4/Figs/pressModel_s' num2str(i)],pressModel);
    end
    close(pressModel)
    
end
spaceplots
end

if skipSingleFigs == 0 ;
figure('position',[116         352        1111         321]);
for i = 1:5
    subplot(3,5,i)
    plot([1:6],[controlEndTime stopTimes_mat(i,:)],'-o'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    ylabel('Bout end time ');
    set(gca,'fontsize',15);
    ylimit = ylim;
    ylim([40 ylimit(2)]);
    subplot(3,5,5+i)
    plot([1:6],[controlEndTime-controlStartTime stopTimes_mat(i,:)-stimEndTimes(1:5)],'-o'); hold on;
    set(gca,'XTick',[1:5]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('Post-stim bout duration ');
    subplot(3,5,10+i)
    controlPostStim_mat = [controlEndTime controlEndTime controlEndTime controlEndTime controlEndTime]-stimEndTimes(1:5);
    pctChangePostStimBlocks_ExE = (([stopTimes_mat(i,:)-stimEndTimes(1:5)]-controlPostStim_mat) ./controlPostStim_mat)*100;
    plot([1:5],pctChangePostStimBlocks_ExE,'-o'); hold on;
    set(gca,'XTick',[1:5]);
    set(gca,'XTickLabel',{'3', '12','21','30','39'});
    ylabel('% change post-stim bout duration')
    set(gca,'fontsize',15);
    
end
spaceplots
end

pctChangeMeanEndTimes = [zeros(5,1) pctChangeFromMeanMatrix([repmat(controlEndTime,5,1) stopTimes_mat])];
% pctChangeMeanNpTillBoutEnd = pctChangeFromMeanMatrix(meanNpTillBoutEnd);

pctChangeMeanNpPostStimTillBoutEnd = [zeros(5,1) pctChangeFromMeanMatrix([repmat([controlEndTime-controlStartTime],5,1) stopTimes_mat-repmat(stimEndTimes(1:5),5,1)])];

% pctChangeMeanBoutDurations_postStim = pctChangeFromMeanMatrix(meanPostStimBoutDurations_probeStm/100);

if skipSingleFigs == 0 ;
figure('position',[121         353        1241         478]);
for i = 1:5
    subplot(2,5,i)
    plot([1:6],pctChangeMeanEndTimes(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change bout end time ');
    ylimit = ylim;
    %     ylim([40 ylimit(2)]);
    subplot(2,5,5+i)
    plot([1:6],pctChangeMeanNpPostStimTillBoutEnd(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change post-stim bout duration ');
    axis tight;
    %%%%%%%
    meanEnd = figure('position',[254   453   270   242]);
    plot([1:6],pctChangeMeanEndTimes(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change bout end time '); xlabel('Stimulation position (s)');
    ylimit = ylim; title('End time');
    spaceplots
    %     ylim([40 ylimit(2)]);
    
    meanNp = figure('position',[254   453   270   242]);
    plot([1:6],pctChangeMeanNpPostStimTillBoutEnd(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change post-stim bout duration '); xlabel('Stimulation position (s)');
    axis tight; title('Post-stim bout duration'); spaceplots
    if wantSave == 1
        save2pdf(['~/Desktop/Jin Lab/Imported Data/Single Lever Ai32 Opto 4/Figs/pctMeanEndModel_s' num2str(i)],meanEnd);
        save2pdf(['~/Desktop/Jin Lab/Imported Data/Single Lever Ai32 Opto 4/Figs/pctMeanPressDurationModel_s' num2str(i)],meanNp);
    end
    close(meanNp); close(meanEnd);
    
    %%%%%%
    %     subplot(3,5,10+i)
    %     controlPostStim_mat = [controlEndTime controlEndTime controlEndTime controlEndTime controlEndTime]-stimEndTimes(1:5);
    %     pctChangePostStimBlocks_ExE = (([stopTimes_mat(i,:)-stimEndTimes(1:5)]-controlPostStim_mat) ./controlPostStim_mat)*100;
    %     plot([1:5],pctChangePostStimBlocks_ExE,'-o'); hold on;
    %     set(gca,'XTick',[1:5]);
    %     set(gca,'XTickLabel',{'3', '12','21','30','39'});
    %     set(gca,'fontsize',15);
    %     ylabel('% change post-stim bout duration ExE')
end
spaceplots

end


figure('position',[ 93          52        1404         896]);
for i = 1:5
    subplot(3,5,i)
    pressBlockLine(1,controlStartTime,controlEndTime,nan,nan,adj);
    for j = 1:5
        pressBlockLine(j+1,controlStartTime,stopTimes_mat(i,j),stimCondStarts(j),stimCondDurs(j),adj);
    end
    ylim([0 j+2]); xlim([0 100]);
    dottedVertLine(controlEndTime,'-',2,'r'); hold on;
    xlabel('Time (s)');
    set(gca,'YTick',[1:1:j+1]);
    set(gca,'YLimMode','manual',...    %# Freeze the current limits
        'YTickMode','manual',...   %# Freeze the current tick values
        'YTickLabel',{'NS', '3', '12','21','30','39'});
    set(gca,'XTick',[0:15:90]);
    set(gca,'fontsize',15);
    %     hold on; plot([controlEndTime stopTimes_mat(i,:)],1:6,'.-');
    %     hold on; plot([controlStartTime stimCondStarts(1:5)+5],1:6,'.-');
    title(titleList(i)); ylabel('Stimulation position (s)');
    subplot(3,5,5+i)
    plot([1:6],pctChangeMeanEndTimes(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change bout end time ');
    ylimit = ylim; title('End time'); xlabel('Stimulation position (s)');
    %     ylim([40 ylimit(2)]);
    subplot(3,5,10+i)
    plot([1:6],pctChangeMeanNpPostStimTillBoutEnd(i,:),'-o','linewidth',5,'color',rgb('red'),'markersize',6,'markerfacecolor','k','markeredgecolor','k'); hold on;
    set(gca,'XTick',[1:6]);
    set(gca,'XTickLabel',{'NS','3', '12','21','30','39'});
    set(gca,'fontsize',15);
    ylabel('% change post-stim bout duration ');
    axis tight; title('Post-stim bout duration'); xlabel('Stimulation position (s)');
    %%%%%%%
end
spaceplots([.01 .01 .01 .02], [.01 .01]);






