%Written by Patrick Strassmann
function plotRewards(pressStackTimes_rwd)
hold on;
for i =1:size(pressStackTimes_rwd,1)
    z = pressStackTimes_rwd(i,:);
    y = find(z>0,1,'last');
    plot(z(y)*10/1000,i,'bo','MarkerSize',6);
    hold on;
end