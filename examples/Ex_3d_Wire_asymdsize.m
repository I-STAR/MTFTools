% Test for asymmetric voxel size (3D wire)
run Setup

%% load data
[u,uSize] = io.multLoadMat('./datasets/3d_Wire_Filter11_Cios.mat','u','uSize');


%% create a downsampled dataset
us{1} = u; uSizes{1} = uSize;
us{2} = u(:,1:2:end,:); uSizes{2} = uSize .* [1 2 1];
us{3} = u(:,:,1:2:end); uSizes{3} = uSize .* [1 1 2];

%% calc
figure(101); hold on;
for i = 1:length(us)
  u = us{i};
  uSize = uSizes{i};
  disp(['Voxel size: ', util.array2str(uSize,' ')]);

  C = mtf.LsfCalc_Wire('uSzScale3d', uSize(1:3), 'theta', pi/2);
  C.fit(u);
  disp(cosd(C.getangPlane));
  C.showFit(u);

  
  pMtf = struct('diffMethod', 'none', 'maxFreq', 2.5);
  pDetrend = struct('bDebug', 0);
  [lsf, lsfAxis] = C.apply(u);
  [mtfVal, mtfAxis] = mtf.sf2Mtf(lsf, lsfAxis, uSize(1), pMtf, pDetrend);
  figure(101);
  plot(mtfAxis, mtfVal,'-*'); 
  xlim([0 1.5*1/(2*uSize(1))]); ylim([0 1]); % x axis: 1.5*Nyquist
  title('MTF'); xlabel('f (cycle/mm)'); ylabel('MTF');
  pause(0.5);
end



