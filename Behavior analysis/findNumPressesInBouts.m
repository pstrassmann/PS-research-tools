% Written by Patrick Strassmann
function numPinBs = findNumPressesInBouts(pressStackMatrix, boutStartTimes, boutEndTimes)

numPinBs = nan(1,size(pressStackMatrix,1));
for i = 1:size(pressStackMatrix,1)
    singleTrialPressMatrix = pressStackMatrix(i,:);
    numPinBs(i) = sum(singleTrialPressMatrix(boutStartTimes(i)*100:boutEndTimes(i)*100));
end

end