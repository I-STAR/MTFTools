run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% determine fit parameters and save
% segmentation
[uBinary] = segnd_th(u, 0.015);
% sphere fit
C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
C.fit(uBinary);
C.showFit(u, 10);


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2);
pDetrend = struct('bDebug', 1);
pApply = {'iSlice', -1:1, 'thetaRg', [-pi pi]};
[esf, esfAxis] = C.apply(u, pApply{:});
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:});
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');

