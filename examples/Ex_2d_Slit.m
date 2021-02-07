% Detector side MTF: 2D slit device
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/2d_slitorwire_proc.mat','u','uSize');


%% determine fit parameters
C = mtf.LsfCalc_Slit('uSzScale', uSize(1:2)/uSize(1));
C.fit(u);
C.showFit(u);


%% MTF calculation
pMtf = struct('diffMethod', 'none', 'maxFreq', 6);
pDetrend = struct('bDebug', 1, 'primaryLength', 8, 'marginLength', 16);
[lsf, lsfAxis] = C.apply(u);
figure; plot(lsfAxis, lsf, '*','MarkerSize',1); title('LSF'); xlabel('unit: voxel'); ylabel('Value');
[mtfVal, mtfAxis] = mtf.sf2Mtf(lsf, lsfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 2*1/(2*uSize(1))]); ylim([0 1]); % x axis: 2*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
