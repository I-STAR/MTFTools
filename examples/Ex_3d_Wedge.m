% 3D MTF from 3D wedge object
% This script loads in a 3D volume dataset of a wedge and calculates the 45 degree MTF (45 degree from the axial plane)
% See our paper on why we think this is a good overall 3D measurement direction
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Wedge_Proc','u','uSize');


%% pre-processing
bbox = [10 70 65 121 118 95];
% crop the wedge edge (45 degree) region in sagittal/coronal plane
u = util.cropbbox( rot90(permute(u,[1 3 2]), -1), bbox );


%% determine fit parameters
[uBinary] = segnd_th(u, 0.015);
% line fit for each-slice (force constant phase shift)
C = mtf.EsfCalc_Wedge('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 3); % show fitting results for three slices


%% MTF calculation
sliceRg = 10:20;
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3); % define the numerical differentiation method and max frequency (unit: Nyquist)
pDetrend = struct('bDebug', 1); % enable debug mode for lsf detrending (also window/center) method

[esf, esfAxis] = C.apply(u, sliceRg); % calculate ESF

figure; plot(esfAxis, esf, '*','MarkerSize',1); title('ESF'); xlabel('# Pixel'); ylabel('Value');

[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend); % calculate MTF

figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF (\phi = 45 degree)'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0; % disable debug mode for lsf detrending (also window/center) method
[esfCel, esfAxisCel] = C.applyMult(nBin, u, sliceRg);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (\phi = 45 degree) (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');