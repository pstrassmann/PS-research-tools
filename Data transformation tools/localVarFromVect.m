% Written by Patrick Strassmann
function [outvect] = localVarFromVect( ipivect )
ipivect = cell2mat(ipivect);
outvect = zeros(1,numel(ipivect)-3);
for ind = 4:numel(ipivect);
    outvect(ind-3) = ipivect(ind)-mean(ipivect(ind-3:ind-1));
end

