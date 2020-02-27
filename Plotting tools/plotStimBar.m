%Written by Patrick Strassmann
function plotStimBar(stimStart,stimStop,Alpha,giveBarExtension)

if nargin<4
    giveBarExtension = 0;
end

if nargin<3
    Alpha = 0.2;
end

if giveBarExtension == 1
    bonus = 100;
else bonus = 0;
end

ylimit = ylim();
hold on;
p=patch([stimStart stimStop stimStop stimStart]*10/1000, [ylimit(1)-bonus ylimit(1)-bonus ylimit(2)+bonus ylimit(2)+bonus],rgb('cyan'));
set(p,'FaceAlpha',Alpha','edgecolor',rgb('cyan'),'edgealpha',Alpha); hold on;

end