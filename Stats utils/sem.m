%Written by Patrick Strassmann

function semOutput = sem(x,dim)
if nargin<2
    dim=1;
end
if size(x,1)==1
       semOutput = std(x,0,2) / sqrt(size(x,2));
elseif size(x,1)>1
    semOutput = nanstd(x,0,dim) ./ sqrt(sum(~isnan(x),dim));
elseif isempty(x)
    semOutput = [];
end