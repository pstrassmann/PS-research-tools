%Written by Patrick Strassmann

function [signVal] = meanDiffSign(exp,orig)

exp = noNans(exp);
orig = noNans(orig);
signVal = sign(mean(exp)-mean(orig));

end

