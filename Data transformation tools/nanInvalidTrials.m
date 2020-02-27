%Written by Patrick Strassmann

function [boutEndTimes, validTrialInds, pressStackMatrix] = nanInvalidTrials(boutEndTimes,boutStartTimes,lowerbound,upperbound)

if isequal(class(boutEndTimes),'cell')
   boutEndTimes = boutEndTimes{1};
   pressStackMatrix = boutEndTimes{2};
end

if nargin<5
    upperbound = 10000;
end
    
if nargin<3
    lowerbound = 3000;
end

invalidTrialInds = boutEndTimes>upperbound | boutStartTimes>lowerbound;
boutEndTimes(invalidTrialInds) = nan;
validTrialInds = ~isnan(boutEndTimes);

if exist('pressStackMatrix','var')
   pressStackMatrix = pressStackMatrix(validTrialInds,:);
else
   pressStackMatrix = [];
end

end

