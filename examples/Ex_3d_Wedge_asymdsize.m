% Test for asymmetric voxel size
run Setup


%% load data, and create a downsampled dataset
[u,uSize] = io.multLoadMat('./datasets/Wedge_Proc.mat','u','uSize');


%% pre-processing
bbox = [10 70 65 121 118 95];
u = util.cropbbox( rot90(permute(u,[1 3 2]), -1), bbox );


%% create a downsampled dataset
us{1} = u; uSizes{1} = uSize;
% two types of asymmetric voxel size
us{2} = u(:,1:2:end,1:2:end); uSizes{2} = uSize .* [1 2 2];
sliceRgs{1} = 10:20; sliceRgs{2} = 5:10; 
% no need to handle dim3 asymmetric voxel size
% us{2} = u(:,:,1:2:end); uSizes{2} = uSize .* [1 1 2];
% sliceRgs{1} = 10:20; sliceRgs{2} = 5:10; 

%% calc
figure; hold on;
for i = 1:length(us)
  u = us{i};
  uSize = uSizes{i};
  disp(['Voxel size: ', util.array2str(uSize,' ')]);

  [uBinary] = segnd_th(u, 0.015);
  C = mtf.EsfCalc_Plane('uSzScale', uSizes{i}(1:2));
  C.fit(uBinary); % fit works of course


  %% MTF calculation
  sliceRg = sliceRgs{i};
  pMtf = struct('diffMethod', 'gradient', 'maxFreq', 3);
  pDetrend = struct('bDebug', 0);
  [esf, esfAxis] = C.apply(u, sliceRg);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(esf, esfAxis, uSize(1), pMtf, pDetrend);
  plot(mtfAxis, mtfVal,'-*'); 
end
xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');

