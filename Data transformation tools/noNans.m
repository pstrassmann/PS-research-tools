% Written by Patrick Strassmann
function [mat] = noNans(inputMat)
mat = inputMat(~isnan(inputMat));
end