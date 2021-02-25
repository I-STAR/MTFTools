% Debug dataset from Esme
% Problem with detrending (i.e. not enough data to property find a trend with the default parameters)
% Axial MTF from one axial slice with a circular object
run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/16cm_Corgi_Cone_Beam_Grid_100_12.mat','u','uSize');


%% determine fit parameters
% segmentation
[uBinary] = seg2d_th(u, 0.03);
% circular fit
C = mtf.EsfCalc_CircRod('uSzScale', uSize(1:2)/uSize(1));
C.fit(uBinary);
C.showFit(u, 1);


%% MTF calculation
thetaRg = deg2rad([-180 180]);

%%% parameter set 1
% pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2, 'bNoDetrend', 1);
% pDetrend = struct('marginLength', 8);

%%% parameter set 2
pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3, 'bNoDetrend', 0);
pDetrend = struct('bDebug', 1, 'primaryLength', 4, 'marginLength', 8);


[esf, esfAxis] = C.apply(u, thetaRg);
figure; plot(esfAxis, esf, '*-');
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


% return;
%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, thetaRg);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');