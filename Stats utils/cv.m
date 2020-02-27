%Written by Patrick Strassmann
function [cv] = cv(vector)
    noNansVect = noNans(vector);
    cv = std(noNansVect)/mean(noNansVect);
end

