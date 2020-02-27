% Written by Patrick Strassmann
function [meanIPI, semIPI, stdIPI, IPIvect] = nanMeanIPIfromStack(IPIStack)
    IPIvect = IPIStack(:);
    IPIvect(isnan(IPIvect))=[];
    meanIPI = mean(IPIvect);
    semIPI = sem(IPIvect);
    stdIPI = std(IPIvect);
end