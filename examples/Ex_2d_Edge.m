% Detector side MTF: 2D edge device
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/2d_Edge_bench2x2.mat','u','uSize');


%% determine fit parameters
[uBinary] = segnd_th(u, 0.8);
% line fit for each-slice (force constant phase shift)
C = mtf.EsfCalc_Plane('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 3);


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 6);
pDetrend = struct('bDebug', 1, 'primaryLength', 8, 'marginLength', 16);
[esf, esfAxis] = C.apply(u);
figure; plot(esfAxis, esf, '*','MarkerSize',1); title('ESF'); xlabel('unit: voxel'); ylabel('Value');
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
