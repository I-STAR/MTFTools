% 3D MTF from 3D plane
% This script loads in a 3D volume dataset of a plane and calculates the MTF that is perpendicular to the plane
% Very similar to Ex_3d_Wedge.m
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Plane_Proc.mat','u','uSize');


%% determine fit parameters
[uBinary] = segnd_th(u, 0.015);
% line fit for each-slice (force constant phase shift)
C = mtf.EsfCalc_Plane('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 3);
disp(['Angle (degree): ', num2str(C.angPlane)]);


%% MTF calculation
sliceRg = []; % empty: use all slices
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug',1,'primaryLength',6,'marginLength',12);
[esf, esfAxis] = C.apply(u, sliceRg);
figure; plot(esfAxis, esf, '*','MarkerSize',1); title('ESF'); xlabel('# Pixel'); ylabel('Value');
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