% Written by Patrick Strassmann
genotypes = fieldnames(dualPeakDataStruct);
criterionOfMax = 0.7;
pkWidthMat_L = nan(numel(genotypes),11);
pkWidthMat_R = nan(numel(genotypes),11);

for i = 1:numel(genotypes)
currGeno = cell2mat(genotypes(i));
subjs = fieldnames(dualPeakDataStruct.(currGeno));
    for j = 1:numel(subjs)
    currSubj = cell2mat(subjs(j));
    ry = dualPeakDataStruct.(currGeno).(currSubj).PETH_Rprobe;
    rx = dualPeakDataStruct.(currGeno).(currSubj).XValues_PETH_Rprobe;
    ly = dualPeakDataStruct.(currGeno).(currSubj).PETH_Lprobe;
    lx = dualPeakDataStruct.(currGeno).(currSubj).XValues_PETH_Lprobe;
    [l1, l2, lpk] = markCriterionPeak(lx,ly,0,criterionOfMax,1);
    [r1, r2, rpk] = markCriterionPeak(rx,ry,0,criterionOfMax,1);
    pkWidthMat_L(i,j) = (l1-l2)/100;
    pkWidthMat_R(i,j) = (r1-r2)/100;
    end
end

nanmean(pkWidthMat_L')
nanmean(pkWidthMat_R')
nanstd(pkWidthMat_L')
nanstd(pkWidthMat_R')

figure('position',[170         425        1070         549]);
barScatter(pkWidthMat_L)
ylimit = ylim();
ylim([0 ylimit(2)]);
xticklabel_rotate(1:numel(genotypes'),20,genotypes','fontsize',15);
ylabel(['Width of ' num2str(criterionOfMax*100) '% peak height (s)'],'fontsize',15);
title(['Width of ' num2str(criterionOfMax*100) '% peak height, 40s Lever'],'fontsize',15);
set(gca,'fontsize',16)

figure('position',[170         425        1070         549]);
barScatter(pkWidthMat_R)
ylimit = ylim();
ylim([0 ylimit(2)]);
xticklabel_rotate(1:numel(genotypes'),20,genotypes','fontsize',15);
ylabel(['Width of ' num2str(criterionOfMax*100) '% peak height (s)'],'fontsize',15);
title(['Width of ' num2str(criterionOfMax*100) '% peak height, 15s Lever'],'fontsize',15);
set(gca,'fontsize',16)