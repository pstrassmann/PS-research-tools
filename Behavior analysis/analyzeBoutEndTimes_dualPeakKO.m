% Written by Patrick Strassmann
genotypes = fieldnames(dualPeakDataStruct);
boutEndTimeMat = nan(numel(genotypes),11);
for i = 1:numel(genotypes)
currGeno = cell2mat(genotypes(i));
subjs = fieldnames(dualPeakDataStruct.(currGeno));
    for j = 1:numel(subjs)
    currSubj = cell2mat(subjs(j));
    boutEndTimeMat(i,j) = nanmean(dualPeakDataStruct.(currGeno).(currSubj).boutEndTimes_Rprobe)/100;
    end
end
figure;
barScatter(boutEndTimeMat)
xticklabel_rotate(1:numel(genotypes'),20,genotypes');