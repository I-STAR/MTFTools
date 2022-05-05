% 3D MTF from 3D sphere object
% This script shows that one can save the fitting parameter (e.g. sphere center, radius) and easily reload them for a different dataset
%   (e.g. different reconstruction kernel)
% See also Ex_3d_Sphere.m
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% determine fit parameters
bRedoFit = 0; % if 1, re-run fitting for this dataset;
if bRedoFit
  [uBinary] = segnd_th(u, 0.015);
  C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
  C.fit(uBinary);
  C.showFit(u, 3);
  C.saveParameters(); % save fitting parameter
end


%% load fit parameters
C = mtf.EsfCalc_Sphere('./datasets/FitPara_Sphere_Filter11_Cios.mat');


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 1);
pApply = {'coneRg', [40 50], 'thetaRg', [-pi pi]};
nBin = 5;
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:});
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (45 degree, with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');

