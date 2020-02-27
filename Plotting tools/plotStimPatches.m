%Written by Patrick Strassmann

function plotStimPatches(relStimTimesOn, relStimTimesOff)

alpha = 0.2;

for i = 1:numel(relStimTimesOn)
    p=patch([relStimTimesOn(i) relStimTimesOff(i) relStimTimesOff(i) relStimTimesOn(i)]*10/1000, [i-.3 i-.3 i+.3 i+.3],rgb('cyan'));
    set(p,'FaceAlpha',alpha','edgecolor',rgb('cyan'),'edgealpha',alpha); hold on;
end

end