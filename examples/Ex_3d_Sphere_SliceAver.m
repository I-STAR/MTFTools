% Showing the effect on axial and 45 degree MTF from slice averaging
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% determine fit parameters
% segmentation
[uBinary] = segnd_th(u, 0.015);
% sphere fit
C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1));
C.fit(uBinary);


%% perform slice averaging
sliceAverAmount = [1 3 5];
sliceAverLegends = arrayfun(@(x) ['# Slice Averaged: ', num2str(x)], sliceAverAmount, 'uni', 0);
us = cell(1, length(sliceAverAmount));
for i = 1:length(us)
  us{i} = SlabVolZ(u, sliceAverAmount(i));
end


%% MTF calculation
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2.5);
pDetrend = struct('bDebug',0);


%%% axial plane
pApplyAxial = {'iSlice', -2:2, 'thetaRg', [-pi 0]};
figure; hold on;
for i = 1:length(us)
  [esf, esfAxis] = C.apply(us{i}, pApplyAxial{:});
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  plot(mtfAxis, mtfVal,'-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF (Axial)'); xlabel('f (cycle/mm)'); ylabel('MTF'); legend(sliceAverLegends,'location','best');


%%% 45 degree
pApply45 = {'coneRg', [40 50], 'thetaRg', [-pi 0]};
figure; hold on;
for i = 1:length(us)
  [esf, esfAxis] = C.apply(us{i}, pApply45{:});
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  plot(mtfAxis, mtfVal,'-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (\phi=45 Degree)'); xlabel('f (cycle/mm)'); ylabel('MTF'); legend(sliceAverLegends,'location','best');


