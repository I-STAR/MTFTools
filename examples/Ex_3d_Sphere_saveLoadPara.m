% Show saving and loading fitting parameters
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% determine fit parameters
bRedoFit = 0;
if bRedoFit
  % segmentation
  [uBinary] = segnd_th(u, 0.015);
  % sphere fit
  C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
  C.fit(uBinary);
  C.showFit(u, 3);
  C.saveParameters();
end


%% load fit parameters
C = mtf.EsfCalc_Sphere('./datasets/FitPara_Sphere_Filter11_Cios.mat');


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 1);
pApply = {'coneRg', [40 50], 'thetaRg', [-pi pi]};
nBin = 5; % number of realizations
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:});
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (45 degree, with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');

