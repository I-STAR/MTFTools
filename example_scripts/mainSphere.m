clear; close all force;

addpath('..');
addpath('../util');

% data path, data should already be pre-processed (cropped etc.)
dPath = '../example_datasets/SingleSphere.mat';
pPath = '../example_datasets/p_SingleSphere.mat';
% flag: set as 1 to determine sphere center etc. 
bDetPara = 0;

[u,uSize] = multLoadMat(dPath,'u','uSize');

%%% determine fitting parameter
if bDetPara
  % figure, mpr(u); % dependency issue, commented off by default
  C = mtf.EsfCalc_SingleSphere();
  C.testFit(u, 'th', 0.018, 'rmSmall', 200, 'pPath', pPath);
  C.saveParameters;
  return
end

%%% mtf calculation parameters
% see `sf2Mtf` for parameter explanation
pMtf.maxFreq = 3;
pMtf.nRmEdge = 5;
pMtf.diffMethod = 'gradient';
pMtf.bDiffCorr = 1;
% see `lsfThrowTrend` for parameter explanation
pDetrend.fh_lsf = 'gauss1';
pDetrend.fh_trend = 'poly1';
pDetrend.primaryLength = 5;
pDetrend.marginLength = 10; 
pDetrend.lsfBase = 0;
pDetrend.bRefit = 0;
pDetrend.bThrowTrend = 1;
pDetrend.bDebug = 1;

%%% mtf calculation
C = mtf.EsfCalc_SingleSphere(pPath);
% 3D mtf, \phi angle from 60 to 70 degree
[esf, esfAxis] = C.apply(u, 'cone', [60 70]);
figure, plot(esfAxis, esf, '*', 'MarkerSize', 3);
[mtfVal, mtfAxis, lsfDetrend, axsDetrend, lsfGrid, axsGrid, sfGrid] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure, plot(mtfAxis, mtfVal, '-*'); axis([0 2 0 1]);

% 2d axial mtf
pDetrend.bDebug = 0;
[esf, esfAxis] = C.apply(u, 'axial');
[mtfVal, mtfAxis, ~, ~] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure, plot(mtfAxis, mtfVal, '-*'); axis([0 2 0 1]);

% 3D mtf, \phi angle from 60 to 70 degree, with errorbar
[esfCel, esfAxisCel] = C.applyMult(u, 3, 'cone', [60 70]);
[mtfVal, mtfAxis, mtfCel, mtfError] = mtf.sf2Mtf_mult(esfCel, esfAxisCel, uSize(1), pMtf, pDetrend);
figure, errorbar(mtfAxis, mtfVal, mtfError, '-*'); axis([0 2 0 1]);