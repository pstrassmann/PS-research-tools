% Script for analysing open-field data
% Written by Patrick Strassmann
rawDataMobile_reshaped = reshape(rawdata_mobile,20,1200);
rawDataVel_reshaped = reshape(rawdata_vel,20,1200);
rawDataXpos_reshaped = reshape(rawdata_xpos,20,1200);
rawDataYpos_reshaped = reshape(rawdata_ypos,20,1200);

velCell_stim = cell(1,12);
xPosCell_stim = cell(1,12);
yPosCell_stim = cell(1,12);
mobilityCell_stim = cell(1,12);

velCell_noStim = cell(1,12);
xPosCell_noStim = cell(1,12);
yPosCell_noStim = cell(1,12);
mobilityCell_noStim = cell(1,12);

for i = 0:11
    start_stim=91+100*i;
    stop_stim = start_stim+4;
    velCell_stim{i+1} = rawDataVel_reshaped(:,start_stim:stop_stim);
    xPosCell_stim{i+1} = rawDataXpos_reshaped(:,start_stim:stop_stim);
    yPosCell_stim{i+1} = rawDataYpos_reshaped(:,start_stim:stop_stim);
    mobilityCell_stim{i+1} = rawDataMobile_reshaped(:,start_stim:stop_stim);

    start_noStim=86+100*i;
    stop_noStim = start_noStim+4;
    velCell_noStim{i+1} = rawDataVel_reshaped(:,start_noStim:stop_noStim);
    velCell_noStim{i+1} = rawDataVel_reshaped(:,start_noStim:stop_noStim);
    xPosCell_noStim{i+1} = rawDataXpos_reshaped(:,start_noStim:stop_noStim);
    yPosCell_noStim{i+1} = rawDataYpos_reshaped(:,start_noStim:stop_noStim);
    mobilityCell_noStim{i+1} = rawDataMobile_reshaped(:,start_noStim:stop_noStim);

end
 
validTrials = find(cellfun(@mean2,mobilityCell_noStim)>0.2);
meanVel_stim = nanmean(cellfun(@mean2,velCell_stim(validTrials)))
meanVel_noStim = nanmean(cellfun(@mean2,velCell_noStim(validTrials)))

meanVel_stim/meanVel_noStim

figure;
for i = validTrials
       plot([xPosCell_noStim{i}(:); xPosCell_stim{i}(:)],[yPosCell_noStim{i}(:); yPosCell_stim{i}(:)],'color',rgb('black'),'linewidth',3);
%         plot(xPosCell_noStim{i}(:),yPosCell_noStim{i}(:),'color',rgb('black'),'linewidth',3);
        
       hold on;
        plot(xPosCell_stim{i}(:),yPosCell_stim{i}(:),'color',rgb('red'),'linewidth',3);
        hold on;
end
    


