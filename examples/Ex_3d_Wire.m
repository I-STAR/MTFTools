% Axial MTF from 3D wire object
run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/3d_Wire_Filter11_Cios.mat','u','uSize');


%% determine fit parameters
C = mtf.LsfCalc_Wire('uSzScale3d', uSize(1:3)/uSize(1), 'theta', pi/2);
C.fit(u);
C.showFit(u);


%% MTF calculation
pMtf = struct('diffMethod', 'none', 'maxFreq', 2);
pDetrend = struct('bDebug',1,'bRefit',1,'primaryLength',5,'marginLength',10);
[lsf, lsfAxis] = C.apply(u);
figure; plot(lsfAxis, lsf, '*','MarkerSize',1); title('LSF'); xlabel('unit: voxel'); ylabel('Value');
[mtfVal, mtfAxis] = mtf.sf2Mtf(lsf, lsfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 3; % number of realizations
pDetrend.bDebug = 0;
[lsfCel, lsfAxisCel] = C.applyMult(nBin, u);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(lsfCel, lsfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');