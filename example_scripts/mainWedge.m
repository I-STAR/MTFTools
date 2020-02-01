% wedge: 45 degree MTF
clear; close all force;

addpath('..');
addpath('../util');

dPath = '../example_datasets/Wedge.mat';
pPath = '../example_datasets/p_Wedge.mat';
bDetPara = 0;

[u,uSize] = multLoadMat(dPath,'u','uSize');
u(u<0) = 0;

if bDetPara
  % figure; mpr(u); % dependency issue, commented off by default
  bbox = [28 34 69 95 77 103]; % crop axial part or 3D part
  C = mtf.EsfCalc_Wedge();
  uOut = C.testPre(u, 'bbox', bbox, 'nSlice', 10, 'fhDim', @(x) permute(x,[3 1 2]));
  C.testFit(uOut);
  C.pPath = pPath;
  C.saveParameters;
  return
end

pMtf.maxFreq = 3;
pMft.nRmEdge = 5;
pDetrend.fh_lsf = 'gauss1';
pDetrend.fh_trend = 'poly1';
pDetrend.primaryLength = 6;
pDetrend.marginLength = 12;
pDetrend.lsfBase = 0;
pDetrend.bThrowTrend = 1;
pDetrend.bDebug = 1;

C = mtf.EsfCalc_Wedge(pPath);
[esf, esfAxis] = apply(C, u);
figure, plot(esfAxis, esf, '*', 'MarkerSize', 1);
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure, plot(mtfAxis, mtfVal, '-*');
axis([0 2 0 1]);