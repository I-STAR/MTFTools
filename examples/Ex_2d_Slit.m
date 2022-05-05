% Detector side MTF from a 2D slit device
% This script loads in a 2D projection dataset of a slit and calculates the MTF perpendicular to the slit
run Setup


%% load data
[u,uSize,slitWidth] = io.multLoadMat('./datasets/2d_SlitWire_Proc.mat','u','uSize','slitWidth');


%% determine fit parameters
C = mtf.LsfCalc_Slit('uSzScale', uSize(1:2)/uSize(1));
C.fit(u);
C.showFit(u);


%% MTF calculation
pMtf = struct('diffMethod', 'none', 'maxFreq', 6);
pDetrend = struct('bDebug', 1, 'primaryLength', 8, 'marginLength', 16);
[lsf, lsfAxis] = C.apply(u);
figure; plot(lsfAxis, lsf, '*','MarkerSize',1); title('LSF'); xlabel('# Pixel'); ylabel('Value');
[mtfVal, mtfAxis] = mtf.sf2Mtf(lsf, lsfAxis, uSize(1), pMtf, pDetrend);

% divide analytical MTF from slit if needed
mtfVal = mtfVal ./ mtf.mtfLine(mtfAxis, slitWidth);

figure; plot(mtfAxis, mtfVal,'-*'); 
xlim([0 2*1/(2*uSize(1))]); ylim([0 1]); % x axis: 2*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
