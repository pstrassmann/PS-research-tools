% Written by Patrick Strassmann
function tbtPeakValues = tbtBoutEndFinder(pressStackMatrix, boutEndTimes, slidingWindowSize, alpha, percentOfPeakMax, wantPlots)

if nargin<5
    wantPlots = 0;
end
tbtPeakValues = nan(1,size(pressStackMatrix,1));
if wantPlots == 1; figure('position',[680   302   883   675]); end
for i = 1:numel(tbtPeakValues)
  [xValues, smoothedTrial] = makeSmoothedPETH(pressStackMatrix(i,:),slidingWindowSize,alpha,0,0,1);
  trueBoutEndTime_trial = boutEndTimes(i);
  disFig = figure; plot(xValues, smoothedTrial); hold on; dottedVertLine(trueBoutEndTime_trial);
  waitforbuttonpress;
  close(disFig);
  if wantPlots ==1
      sq = sqrt(numel(tbtPeakValues));
      if sq-fix(sq)>0.5
          spX = ceil(sq);
          spY = ceil(sq);
      else
          spX = ceil(sq);
          spY = fix(sq);
      end
      subplot(spX,spY,i)
      plot(xValues*10/1000,smoothedTrial); hold on;
  end
  peakValue = markCriterionPeak(xValues,smoothedTrial, 0, percentOfPeakMax,~wantPlots);
  if isempty(peakValue)==0; tbtPeakValues(i) = peakValue; end
end
if wantPlots ==1; spaceplots();end

end