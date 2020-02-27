% Written by Patrick Strassmann
function [ matrix ] = zerosToNans( matrix )
    matrix(matrix==0)=nan;
end

