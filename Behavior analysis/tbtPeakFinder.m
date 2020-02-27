% Written by Patrick Strassmann
function tbtPeakValues = tbtPeakFinder(pressStackMatrix,slidingWindowSize, alpha, percentOfPeakMax,shiftValue, wantPlots)
if nargin<6
    wantPlots = 0;
end
if shiftValue == 0
    alignedOrUnaligned = 0;
else
    alignedOrUnaligned = 1;
end
tbtPeakValues = nan(1,size(pressStackMatrix,1));
if wantPlots == 1; figure('position',[680   302   883   675]); end
for i = 1:numel(tbtPeakValues)
  [xValues, smoothedTrial] = makeSmoothedPETH(pressStackMatrix(i,:),slidingWindowSize,alpha, alignedOrUnaligned);
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
      plot(xValues+shiftValue*10/1000,smoothedTrial); hold on;
  end
  peakValue = markCriterionPeak(xValues,smoothedTrial, shiftValue, percentOfPeakMax,~wantPlots);
  if isempty(peakValue)==0; tbtPeakValues(i) = peakValue; end
end
if wantPlots ==1; spaceplots();end

end