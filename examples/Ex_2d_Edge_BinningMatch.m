% Detector side MTF of different binning mode (and can be almost matched by dividing the binning aperture)
run Setup


dNames = {'2d_Edge_bench1x1.mat', '2d_Edge_bench2x2.mat'};
legends = {'Binning: 1x1', 'Binning: 2x2'};
figure(1); hold on;
figure(2); hold on;
for i = 1:length(dNames)
  %% load data
  dPath = ['./datasets/' dNames{i}];
  [u,uSize] = io.multLoadMat(dPath,'u','uSize');


  %% determine fit parameters
  [uBinary] = segnd_th(u, 0.8);
  % line fit for each-slice (force constant phase shift)
  C = mtf.EsfCalc_Plane('uSzScale', uSize(1:2)/uSize(1));
  C.fit(uBinary);
  % C.showFit(u, 3);


  %% MTF calculation
  pMtf = struct('diffMethod', 'gradient', 'maxFreq', 5);
  pDetrend = struct('bDebug', 1, 'primaryLength', 7, 'marginLength', 14);
  [esf, esfAxis] = C.apply(u);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);

  figure(1); plot(mtfAxis, mtfVal,'-*'); 
  figure(2); plot(mtfAxis, mtfVal ./ sinc(mtfAxis * uSize(1)),'-*'); 
end
figure(1); xlim([0 2.8]); ylim([0 1]); title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF'); legend(legends);
figure(2); xlim([0 2]); ylim([0 1]); title('MTF (Divide Sinc)'); xlabel('f (cycle/mm)'); ylabel('MTF'); legend(legends);