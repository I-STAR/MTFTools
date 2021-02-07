% Test for asymmetric voxel size (circular rod)
run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/Rod_Proc.mat','u','uSize');


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

  C = mtf.EsfCalc_CircRod('uSzScale', uSize(1:2)/uSize(1));
  C.fit(segnd_th(u, 0.015));
  % C.showFit(u, 5);

  % Use `2*uSize(1)/uSize1`, not simply 2 --> so that the absolute (cycle/mm) is the same
  pMtf = struct('diffMethod', 'gradient', 'maxFreq', 2*uSize(1)/uSize1);
  pDetrend = struct('bDebug', 0);
  iSlice = []; 
  [esf, esfAxis] = C.apply(u, [-pi pi], iSlice);
  % figure; plot(esfAxis, esf, '*', 'MarkerSize', 1);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  figure(101);
  plot(mtfAxis, mtfVal,'-*'); 
  xlim([0 2.5]); ylim([0 1]); % x axis: 1.5*Nyquist
  title('MTF (45 Degree)'); xlabel('f (cycle/mm)'); ylabel('MTF');
end



