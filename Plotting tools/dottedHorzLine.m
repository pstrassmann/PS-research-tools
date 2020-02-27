% Written by Patrick Strassmann

function [dottedHorzLine] = dottedHorzLine(yValue,linestyle,linewidth,color)

if nargin<4
    color='k';
end

if nargin<2
    linestyle = ':';
end

if nargin<3
    linewidth = 1;
end

hold on;
dottedHorzLine = line(xlim, [yValue yValue]);
set(dottedHorzLine,'Color',color,'LineStyle',linestyle, 'Linewidth',linewidth); hold on;

end