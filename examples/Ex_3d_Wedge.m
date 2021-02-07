% 3D MTF from 3D wedge 
run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/Wedge_Proc.mat','u','uSize');


%% pre-processing
bbox = [10 70 65 121 118 95];
u = util.cropbbox( rot90(permute(u,[1 3 2]), -1), bbox );


%% determine fit parameters
[uBinary] = segnd_th(u, 0.015);
% line fit for each-slice (force constant phase shift)
C = mtf.EsfCalc_Wedge('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 3);


%% MTF calculation
sliceRg = 10:20;
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 1);
[esf, esfAxis] = C.apply(u, sliceRg);
figure; plot(esfAxis, esf, '*','MarkerSize',1); title('ESF'); xlabel('unit: voxel'); ylabel('Value');
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, sliceRg);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');