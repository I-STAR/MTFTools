% Show sphere MTF measurement for different cone angles \phi
run Setup


%% load data
% this dataset has strong apodization in axial plane than that in z direction
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter0308_Cios.mat','u','uSize');


%% load fit parameters
[uBinary] = segnd_th(u, 0.015);
C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1), 'pPath', './datasets/FitPara_Sphere_Filter11_Cios.mat');
C.fit(uBinary);



%% MTF calculation for different phis
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 0);

coneAngs = linspace(0, 80, 6);
legends = arrayfun(@(x) ['Cone Angle (\phi): ', num2str(x)], coneAngs, 'uni', 0);
figure; hold on;
for i = 1:length(coneAngs)
  pApply = {'coneRg', coneAngs(i) + [-5 5], 'thetaRg', [-pi pi]};
  [esf, esfAxis] = C.apply(u, pApply{:});
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  plot(mtfAxis, mtfVal,'-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
legend(legends,'location','best');



figure; hold on;
nBin = 5;
for i = 1:length(coneAngs)
  pApply = {'coneRg', coneAngs(i) + [-5 5], 'thetaRg', [-pi pi]};
  [esfCel, esfAxisCel] = C.applyMult(nBin, u, pApply{:});
  [mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
  errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF (with errorbars)'); xlabel('f (cycle/mm)'); ylabel('MTF');
legend(legends,'location','best');


