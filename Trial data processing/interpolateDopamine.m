% Written by Patrick Strassmann
function interpolatedDopamineTrials = interpolateDopamine(trials_norm)
interpolatedDopamineTrials = [];
trials_norm = trials_norm';
for j = 1:size(trials_norm,2)
    column = trials_norm(:,j);
    interpColumn = interp1(1:numel(column),column,1:.1:numel(column));
    interpColumn = [repmat(interpColumn(1),1,9) interpColumn];
    interpolatedDopamineTrials = [interpolatedDopamineTrials; interpColumn];
end
end