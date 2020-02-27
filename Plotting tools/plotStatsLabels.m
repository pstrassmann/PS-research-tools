%Written by Patrick Strassmann

function [] = plotStatsLabels(stackedBoutTimes, boutStartTimes, boutDurations,tbtPeakTimes, sigMat)
if nargin<5
    sigMat = [0 0 0 0];
    forNoStim = 1;
end
if nargin<4
    tbtPeakTimes = nan;
end

meanNumPressesPerBout = mean(sum(stackedBoutTimes>0,2));
cvNumPressesPerBout = cv(sum(stackedBoutTimes>0,2));

boutEndTimes = boutStartTimes+boutDurations;

tbtPk_sig = [char(sigMat(1)*42)];
Lat_sig = [char(sigMat(2)*42)];
Dur_sig = [char(sigMat(3)*42)];
numPresses_sig = [char(sigMat(4)*42)];
if numel(sigMat)>4
End_sig = [char(sigMat(5)*42)];
end;

if tbtPk_sig == char(0); tbtPk_sig = ' '; end
if Lat_sig == char(0); Lat_sig = ' '; end
if Dur_sig == char(0); Dur_sig = ' '; end
if numPresses_sig == char(0); numPresses_sig = ' '; end
if numel(sigMat)>4
    if End_sig == char(0); End_sig = ' '; end
elseif forNoStim==1
    End_sig = ' ';
else
    End_sig = '?';
end

noNansBoutEndTimes = boutEndTimes(~isnan(boutEndTimes));
noNansBoutStartTimes = boutStartTimes(~isnan(boutStartTimes));
noNansBoutDurations = boutDurations(~isnan(boutDurations));
noNansTbtPeakTimes = noNans(tbtPeakTimes);
xlimit = xlim();
ylimit = ylim();
text(xlimit(2)*.65,ylimit(2)*.88,[ tbtPk_sig 'tbtPk=' num2str(mean(noNansTbtPeakTimes)*10/1000,'%.1f') 's'],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.81,[' cvTbtPk=' num2str(std(noNansTbtPeakTimes)/mean(noNansTbtPeakTimes),'%.3f')],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.74,[Lat_sig 'Lat=' num2str(mean(noNansBoutStartTimes)*10/1000,'%.1f') 's' ],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.67,[' cvLat=' num2str(std(noNansBoutStartTimes)/mean(noNansBoutStartTimes),'%.3f')],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.60,[End_sig 'End=' num2str(mean(noNansBoutEndTimes)*10/1000,'%.1f') 's' ],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.53,[' cvEnd=' num2str(std(noNansBoutEndTimes)/mean(noNansBoutEndTimes),'%.3f')],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.44,[Dur_sig 'Dur=' num2str(mean(noNansBoutDurations)*10/1000,'%.1f') 's' ],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.37,[' cvDur=' num2str(std(noNansBoutDurations)/mean(noNansBoutDurations),'%.3f')],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.30,[numPresses_sig 'P/B=' num2str(meanNumPressesPerBout,'%.1f') ],'FontSize',8); hold on;
text(xlimit(2)*.65,ylimit(2)*.23,[' cvP/B=' num2str(cvNumPressesPerBout,'%.3f')],'FontSize',8); hold on;



