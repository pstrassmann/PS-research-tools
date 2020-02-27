% Written by Patrick Strassmann

function [dottedVertLine] = dottedVertLine(xValue,linestyle,linewidth,color)

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
dottedVertLine = line([xValue xValue], ylim);
set(dottedVertLine,'Color',color,'LineStyle',linestyle, 'Linewidth',linewidth); hold on;

end