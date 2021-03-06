% Written by Patrick Strassmann
% Saves accurate-to-screen, high resolution copy of current figure
function saveGoodFig(figHandle,figName,figPos)
if nargin<1
     [currFileName, currPathName, currFilterIndex] = uiputfile();
     figHandle = gcf;
     figName = [currPathName currFileName];
end
if nargin<3
set(figHandle, 'PaperPositionMode', 'auto'); pause(0.05); print(figHandle, figName, '-dpng', '-r300');  %fixPSlinestyle([figName '.eps']); eps2raster([figName '.eps'],'png'); delete([figName '.eps']);
else
set(figHandle,'Position',figPos);
set(figHandle, 'PaperPositionMode', 'auto'); pause(0.05); print(figHandle, figName, '-dpng', '-r300');  %fixPSlinestyle([figName '.eps']); eps2raster([figName '.eps'],'png'); delete([figName '.eps']);
end

