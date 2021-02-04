% Test for asymmetric voxel size
run Setup


%% load data
[u,uSize] = io.multLoadMat('./datasets/Sphere_Filter11_Cios.mat','u','uSize');


%% create a downsampled dataset
uSize1 = uSize(1);
us{1} = u; uSizes{1} = uSize;
us{2} = u(1:2:end,:,:); uSizes{2} = uSize .* [2 1 1];
us{3} = u(:,1:2:end,:); uSizes{3} = uSize .* [1 2 1];
us{4} = u(:,:,1:2:end); uSizes{4} = uSize .* [1 1 2];

%% calc
figure(101); hold on;
for i = 1:length(us)
  u = us{i};
  uSize = uSizes{i};
  disp(['Voxel size: ', util.array2str(uSize,' ')]);

  C = mtf.EsfCalc_Sphere('uSzScale', uSize(1:3)/uSize(1));
  C.fit(segnd_th(u, 0.015));
  % C.showFit(u, 5);

  % Use `2*uSize(1)/uSize1`, not simply 2 --> so that the absolute (cycle/mm) is the same
  pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2*uSize(1)/uSize1);
  pDetrend = struct('bDebug', 0);
  pApply45 = {'coneRg', [40 50], 'thetaRg', [-pi pi]};
  [esf, esfAxis] = C.apply(u, pApply45{:});
  % figure; plot(esfAxis, esf, '*', 'MarkerSize', 1);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  figure(101);
  plot(mtfAxis, mtfVal,'-*'); 
  xlim([0 2.5]); ylim([0 1]); % x axis: 1.5*Nyquist
  title('MTF (45 Degree)'); xlabel('f (cycle/mm)'); ylabel('MTF');
end



