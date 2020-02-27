% Written by Patrick Strassmann
% Saves accurate-to-screen, high resolution figure in EPS format
function saveGoodEps(figHandle,figName,figPos)
if nargin<1
     [currFileName, currPathName, currFilterIndex] = uiputfile();
     figHandle = gcf;
     figName = [currPathName currFileName];
end
figHandle.Renderer = 'Painters';
if nargin<3
set(figHandle, 'PaperPositionMode', 'auto'); pause(0.05); print(figHandle, figName, '-depsc', '-r300');  %fixPSlinestyle([figName '.eps']); eps2raster([figName '.eps'],'png'); delete([figName '.eps']);
else
set(figHandle,'Position',figPos);
set(figHandle, 'PaperPositionMode', 'auto'); pause(0.05); print(figHandle, figName, '-depsc', '-r300');  %fixPSlinestyle([figName '.eps']); eps2raster([figName '.eps'],'png'); delete([figName '.eps']);
end

