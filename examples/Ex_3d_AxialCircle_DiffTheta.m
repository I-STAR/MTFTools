% Axial MTF from one axial slice with a circular object (for different \theta)
% This script loads in a 2D axial slice of a circle/rod and calculates the MTF for different \theta
%   (An asymmetric smoothing is applied to the circle/rod to show different results with respect to \theta)
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/3d_AxialCircle_Precision.mat','u','uSize');


%% determine fit parameters
% segmentation
[uBinary] = seg2d_th(u, 0.015);
% circular fit
C = mtf.EsfCalc_CircRod('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 1);


%% apply theta-dependent smoothing
u = imgaussfilt(u, [0.1 2]);
figure; imshow(u,[]);


%% MTF calculation
thetaCenters = linspace(-180, 0, 6);
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
pDetrend = struct('bDebug', 0);

figure; hold on;
for i = 1:length(thetaCenters)
  % (\theta = thetaCenters(i) degree; \theta_b = 30 degree, see our paper for definitions)
  thetaRg = deg2rad(thetaCenters(i) + [-30 30]);
  [esf, esfAxis] = C.apply(u, thetaRg);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  plot(mtfAxis, mtfVal,'-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
legend(arrayfun(@(x) ['Angle: ', num2str(x)], thetaCenters, 'uni', 0),'location','best');

