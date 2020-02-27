%Written by Patrick Strassmann

function [criterionPeakTime, firstCriterionTime, lastCriterionTime ] = markCriterionPeak(corrXvaluesForPETH, smoothedPETH, shiftValue,  criterionOfMax, noPlotting,putPeakTimeLabel, scalingFactor)

if nargin<7
    scalingFactor = 1;
end
if nargin<6
        putPeakTimeLabel = 1;
end
if nargin<5
    noPlotting = 0;
end

peakLimitTime = 6000;

if numel(corrXvaluesForPETH)>0
    smoothCorr = corrXvaluesForPETH(1)/10*1000;

    if numel(smoothedPETH)<peakLimitTime-fix(smoothCorr)
        maxSmoothedPressRate = max(smoothedPETH);
    else
        maxSmoothedPressRate = max(smoothedPETH(1:peakLimitTime-fix(smoothCorr)));

    end
    firstCriterionPressRateTime = smoothCorr + find(smoothedPETH>criterionOfMax*maxSmoothedPressRate,1,'first');
    lastCriterionPressRateTime = smoothCorr + find(smoothedPETH>criterionOfMax*maxSmoothedPressRate);
    lastCriterionPressRateTime = max(lastCriterionPressRateTime(lastCriterionPressRateTime<peakLimitTime));
    criterionPeakTime = shiftValue+(lastCriterionPressRateTime + firstCriterionPressRateTime)/2;
    if noPlotting == 0
        plot((shiftValue+firstCriterionPressRateTime)*10/1000*scalingFactor,smoothedPETH(round(firstCriterionPressRateTime-smoothCorr)),'ko','LineWidth',1,'MarkerFaceColor',[0.8516    0.6445    0.1250]); hold on
        try 
            plot((shiftValue+lastCriterionPressRateTime)*10/1000*scalingFactor,smoothedPETH(lastCriterionPressRateTime-smoothCorr),'ko','LineWidth',1,'MarkerFaceColor',[0.8516    0.6445    0.1250]); hold on
        catch
            plot((shiftValue+lastCriterionPressRateTime)*10/1000*scalingFactor,smoothedPETH(round(lastCriterionPressRateTime-smoothCorr)),'ko','LineWidth',1,'MarkerFaceColor',[0.8516    0.6445    0.1250]);
        end
        hold on
            plot(criterionPeakTime*10/1000*scalingFactor,smoothedPETH(round(criterionPeakTime-smoothCorr-shiftValue)),'ko','LineWidth',1,'MarkerFaceColor','y'); hold on
        xlimit = xlim();
        ylimit = ylim();
        if putPeakTimeLabel==1
            text(xlimit(2)*.5,ylimit(2)*.95,[' mnPk=' num2str(criterionPeakTime*10/1000*scalingFactor,'%.1f') 's'],'FontSize',8);
        end
    end
    if putPeakTimeLabel==2
        xlimit = xlim();
        ylimit = ylim();
        text(xlimit(2)*.65,ylimit(2)*.95,[' mnPk=' num2str(criterionPeakTime*10/1000*scalingFactor,'%.1f') 's'],'FontSize',8);
    end

    firstCriterionTime = (firstCriterionPressRateTime + shiftValue)*scalingFactor;
    lastCriterionTime = (lastCriterionPressRateTime + shiftValue)*scalingFactor;
else
    criterionPeakTime = [];
end