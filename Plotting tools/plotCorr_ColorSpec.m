%Written by Patrick Strassmann
function [rvalMat,pValMat, fitY_cell] = plotCorr_ColorSpec(x_cell,y_cell,wantPlots,colorDots, colorLine, subplotSpec)

if isequal(class(x_cell),'double') && isequal(class(y_cell),'double')
    x_cell = {x_cell}; %converts double array to cell
    y_cell = {y_cell}; %converts double array to cell
end

if nargin<6
    sq = sqrt(numel(x_cell));
    if sq-fix(sq)>0.5
        spX = ceil(sq);
        spY = ceil(sq);
    else
        spX = ceil(sq);
        spY = fix(sq);
    end
else
    spX = subplotSpec(1);
    spY = subplotSpec(2);
end

if nargin<5
    colorLine = 'r';
end

if nargin<3
    wantPlots = 1;
end

if nargin<4
    colorDots = 'k';
end
xlimit_o = [0 0];
ylimit_o = [0 0];
rvalMat = nan(size(x_cell,1),size(x_cell,2));
pValMat = nan(size(x_cell,1),size(x_cell,2));

fitY_cell = cell(size(x_cell,1),size(x_cell,2));

    for i = 1:size(x_cell,1)
        for j = 1:size(x_cell,2)
            x = x_cell{i,j};
            y = y_cell{i,j};
            [corrcoeffs, p] = corrcoef(x,y);
            rval = corrcoeffs(1,2);
            pval = p(1,2);
            rvalMat(i,j) = rval;
            pValMat(i,j) = pval;
            ffitP = polyfit(x,y,1);
            fitY = polyval(ffitP,x);
            fitY_cell{i,j} = fitY;
            
            if wantPlots ==1
                subplot(spX,spY,j)
                plot(x,y,'o','markersize',6,'markerfacecolor',colorDots,'markeredgecolor','k')
                hold on; plot(x,fitY,'color',colorLine,'linewidth',3);
                title(['r=' num2str(rval,'%.3f') ', p=' num2str(pval)]);
                set(gca,'fontsize',15);
                axis tight;
                xlimit = xlim();
                ylimit = ylim();
                if xlimit(1)<xlimit_o(1); xlimit_o(1) = xlimit(1); end
                if xlimit(2)>xlimit_o(2); xlimit_o(2) = xlimit(2); end
                if ylimit(1)<ylimit_o(1); ylimit_o(1) = ylimit(1); end
                if ylimit(2)>ylimit_o(2); ylimit_o(2) = ylimit(2); end;

            end
        end
    end
end





