run Setup


%% load data
[us,uSize] = io.multLoadMat('./datasets/3d_anatomy_kagaku.mat','us','uSize');


%% find a bounding box
% figure; imshow(us{3},[0.018 0.022]);
% bbox = util.getbbox_imrect();
bbox = [383   242   415   277];
us = cellfun(@(x) util.cropbbox(x, bbox), us, 'uni', 0);


%% determine fit parameters and save
% perform fit on the one with the hightest quality
uFit = imadjust(us{3}, [0.015 0.025], [0 1]);
C = mtf.EsfCalc_Irregular('pEdge',{'Canny',[0.1 0.9],5});
C.fit(uFit);
C.showFit(us{3}); % return;


%% ESF width calculation
for i = 1:length(us)
  [esf, esfAxis] = C.apply(us{i});
  % esfWidth (unit: mm, fits on err function (\sigma))
  [esfWidth, fitRes] = mtf.calcEsfWidth(esf, esfAxis, uSize(1), 'bDebug', 1);
end
% so one would need to increase FBP smoothing, reduce PWLS smoothing


%% Multiple ESF Calculation
nBin = 3; % number of realizations
[esfCel, esfAxisCel] = C.applyMult(nBin, us{3});
for i = 1:nBin
  [esfWidth, ~] = mtf.calcEsfWidth(esfCel{i}, esfAxisCel{i}, uSize(1), 'bDebug', 1);
end

