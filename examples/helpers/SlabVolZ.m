function [VolOut] = SlabVolZ(VolIn, SlabAmnt, FillVal)
% This function slabs an image volume in the z direction for display.
% This will do an interleaved slabbing, where each slab corresponds to an
%   average of the current slab and however many slices specified by slabamnt.
% INPUTS: VolIn is the input volume, SlabAmnt is the number of slices to average

    if nargin < 2 || isempty(SlabAmnt)
        SlabAmnt = 2;
        FillVal = prctile(VolIn(:), 5);
    end
    if nargin <3
        FillVal = prctile(VolIn(:), 5);
    end
    if SlabAmnt < 2
        VolOut = VolIn;
        return;
    end
    inds = cat(1, 1:SlabAmnt, -(1:SlabAmnt));
    inds = reshape(inds, 1, 2*length(inds));
    slabinds =[0, inds(1:(SlabAmnt-1))];
    VolOut = zeros(size(VolIn));
    for sn = 1:SlabAmnt
        VolOut = VolOut + shiftvol(VolIn, slabinds(sn), FillVal);
    end
    VolOut = VolOut/SlabAmnt;
end

function [volshift] = shiftvol(volshift, shiftamnt, FillVal)
    if shiftamnt > 0
        volshift = cat(3, FillVal*ones(size(volshift, 1), size(volshift, 2), shiftamnt), ...
                    volshift(:, :, (1:(end-shiftamnt))));
    elseif shiftamnt < 0
        volshift = cat(3, volshift(:, :, ((-shiftamnt+1):end)), ...
                    FillVal*ones(size(volshift, 1), size(volshift, 2), -shiftamnt));
    end
end