% 3D MTF from 3D sphere object
% This script loads in a 3D volume dataset of a sphere and calculates the MTF along a particular direction (see `pApply` parameter below)
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% determine fit parameters and save
% segmentation
[uBinary] = segnd_th(u, 0.015);

% sphere fit
C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
C.fit(uBinary);
% display 10 (slices equally spaced from top to bottom) example sphere fit results
% slices that do not contain a sphere will be omitted
% sphere contour/edge will be shown in yellow
C.showFit(u, 10); 


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2); % define the numerical differentiation method and max frequency (unit: Nyquist)
pDetrend = struct('bDebug', 1); % enable debug mode for lsf detrending (also window/center) method

% uncomment one option below (for a particular direction)
% axial 
% pApply = {'iSlice', -1:1, 'thetaRg', [-pi pi]}; % use for axial MTF
% cone 45 degree (\phi = 45 degree; \phi_b = 5 degree, see our paper for definitions)
pApply = {'coneRg', [40 50], 'thetaRg', [-pi pi]}; % use for MTF(phi = 45 deg)
% z (approximate) direction (\phi = 82.5 degree; \phi_b = 2.5 degree, see our paper for definitions)
% pApply = {'coneRg', [80 85], 'thetaRg', [-pi pi]}; % use for MTF(phi = 82.5 deg)(close to z, but avoids null-cone)


[esf, esfAxis] = C.apply(u, pApply{:}); % calculate ESF
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend); % calculate MTF

%%% visualization
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0; % disable debug mode for lsf detrending (also window/center) method
[esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:}); % compute the ESF from multiple realizations
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend); % calculate MTF for each ESF realization

%%% visualization
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');

