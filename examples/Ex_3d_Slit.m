% Axial MTF from 3D slit object
% This script loads in a 3D volume dataset of a slit and calculates the MTF perpendicular to the slit
run Setup


%% load data
% slitWidth: mm
[u,uSize,slitWidth] = io.multLoadMat('./datasets/3d_CorgiSlit_CSH.mat','u','uSize','slitWidth');


%% pre-processing
u = mean(maxk(u(:),10)) - u; % make the slit "bright"


%% determine fit parameters
C = mtf.LsfCalc_Slit('uSzScale', uSize(1:2)/uSize(1));
C.fit(u);
C.showFit(u, 3); % example three slices slit fitting
disp(['Angle (degree): ', num2str(C.angPlane)]);


%% MTF calculation
sliceRg = []; % empty: use all slices
pMtf = struct('diffMethod', 'none', 'maxFreq', 3); % no diff method needed (since already LSF, not ESF)
pDetrend = struct('bDebug',1,'bRefit',1); % see `lsfDetrendWdCenter` for parameter definitions

[esf, esfAxis] = C.apply(u, sliceRg); % calculate ESF
figure; plot(esfAxis, esf, '*','MarkerSize',1); title('ESF'); xlabel('# Pixel'); ylabel('Value');

[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend); % calculate MTF
% divide analytical MTF from slit if needed
mtfVal = mtfVal ./ mtf.mtfLine(mtfAxis, slitWidth);
figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');


%% MTF calculation (multiple realization / errorbar)
nBin = 5; % number of realizations
pDetrend.bDebug = 0;
[esfCel, esfAxisCel] = C.applyMult(nBin, u, sliceRg);
[mtfVal, mtfAxis, ~, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
% divide analytical MTF from slit if needed
mtfVal = mtfVal ./ mtf.mtfLine(mtfAxis, slitWidth);
figure; errorbar(mtfAxis, mtfVal, mtfError, '-*'); 
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); 
title('MTF (with errorbar)'); xlabel('f (cycle/mm)'); ylabel('MTF');