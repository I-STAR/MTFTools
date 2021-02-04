run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/Rod_Proc.mat','u','uSize');


%% determine fit parameters
% segmentation
[uBinary] = segnd_th(u, 0.015);
% circular fit
C = mtf.EsfCalc_CircRod('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 3);


%% MTF calculation
iSlice = 10:20; 
thetaRg = []; % deg2rad([-180 -90]);
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 1);
[esf, esfAxis] = C.apply(u, thetaRg, iSlice);
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend = struct('bDebug', 0);
[esfCel, esfAxisCel] = C.applyMult(nBin, u, thetaRg, iSlice);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');