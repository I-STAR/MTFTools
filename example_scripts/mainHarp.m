clear; close all force;

addpath('..');
addpath('../util');

dPath = '../example_datasets/Harp.mat';
pPath = '../example_datasets/p_Harp.mat';
bDetPara = 0;

[u,uSize] = multLoadMat(dPath,'u','uSize');
u(u<0) = 0;

if bDetPara
  % figure; mpr(u); % dependency issue, commented off by default
  C = mtf.EsfCalc_Harp();
  C.testFindWire(u, 'fh_Binarize', @(x) x > 0.01, 'bRmLastFour', 1);
  C.pPath = pPath;
  C.mipShowWires(u, [20 20 40]);
  idx = [25 9];
  direc = [1 2];
  C.chooseWireAndFit(u, idx, direc, [40 40 30]);
  C.saveParameters;
  return
end

pMtf.maxFreq = 3;
pMtf.nRmEdge = 5;
pMtf.diffMethod = 'none';
pMtf.bDiffCorr = 0;
pDetrend.fh_lsf = 'gauss1';
pDetrend.fh_trend = 'poly1';
pDetrend.primaryLength = 5;
pDetrend.marginLength = 10;
pDetrend.lsfBase = 0;
pDetrend.bThrowTrend = 1;

C = mtf.EsfCalc_Harp(pPath);
[esf, esfAxis] = apply(C, u, 1);
figure, plot(esfAxis, esf, '*', 'MarkerSize', 3);
[mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
figure, plot(mtfAxis, mtfVal, '-*');
axis([0 2 0 1]);