run Setup


%% load data
[u,uSize,slitWidth] = io.multLoadMat('./datasets/3d_CorgiSlit_CSH.mat','u','uSize','slitWidth');


%% pre-processing
u = mean(maxk(u(:),10)) - u;


%% determine fit parameters
C = mtf.LsfCalc_Slit('uSzScale', uSize(1:2)/uSize(1));
C.fit(u);
C.showFit(u, 3);
disp(['Angle (degree): ', num2str(C.angPlane)]);


%% MTF calculation
sliceRg = []; % empty: use all slices
pMtf = struct('diffMethod', 'none', 'maxFreq', 3);
pDetrend = struct('bDebug',1,'bRefit',1);
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