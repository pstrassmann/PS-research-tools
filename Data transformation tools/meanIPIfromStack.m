% Written by Patrick Strassmann
function [meanIPI, semIPI, stdIPI, IPIvect] = meanIPIfromStack(IPIStack)
    IPIvect = IPIStack(:);
    IPIvect(IPIvect==0)=[];
    meanIPI = mean(IPIvect);
    semIPI = sem(IPIvect);
    stdIPI = std(IPIvect);
end