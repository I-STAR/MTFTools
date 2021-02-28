classdef EsfCalc_CircRod < mtf.SfCalc
% Calculate axial ESF from a circular Rod (3D) / single circle (2D axial slice from a 3D rod)


properties
  cents % circle center for each slice (N*2), N can be 1, unit: pixel
  radius % circle radius (scalar, same for each slice), unit: pixel
  uSzScale = [1 1] % handles asymmetric element spacing
  rRg = [0.4 1.6] % empty: use the entire radial length
end
properties (Hidden)
  bLineFit3d = 1 % make sure that fitted circle centers from each slice lie on the same 3D line (rod)
  pDraw = {'Color','y','LineWidth',1} % for builtin `line` function, drawing
end


methods
  function o = EsfCalc_CircRod(varargin)
    o.parseinput(varargin{:});
  end


  function [] = set.uSzScale(o, in)
    assert(isnumeric(in) && length(in) == 2);
    o.uSzScale = in;
  end


  function [] = fit(o, uBinary)
  % Fit circle for each slice
  % `uBinary`: pre-segmented volume
    nSlice = size(uBinary,3);
    cents_ = zeros(nSlice,2);
    radiuss = zeros(1,nSlice);
    for i = 1:nSlice
      [cents_(i,:), radiuss(i)] = vision.circFit_image(uBinary(:,:,i), o.uSzScale);
    end
    o.radius = mean(radiuss);
    if o.bLineFit3d && size(uBinary, 3) > 2
      [centsnew, ~, ~] = vision.linefit3d([cents_, transpose(1:nSlice)]);
      o.cents = centsnew(:,1:2);
    else
      o.cents = cents_;
    end
  end


  function [] = showFit(o, u, nSlice)
  % Show fitting results
  % u: original volume 
  % nSlice: number of slices to visualize
    if nargin == 2 || isempty(nSlice)
      nSlice = size(u,3);
    end
    iSlice = fix(linspace(1, size(u,3), min(size(u,3), nSlice)));
    for i = iSlice
      h = figure; imshow(u(:,:,i), []);
      vision.drawcirc_scaler(o.cents(i,:), o.radius, 'handle', h, 'dSize', o.uSzScale, 'pDraw', o.pDraw);
    end
  end


  function [esf, esfAxs, msk] = apply(o, u, thetaRg, iSlice)
  % Calculate ESF and its axis (in voxel)
  % u: volume 
  % thetaRg: range of theta (rad), e.g. [-pi pi]; See our MTF paper. 
  % iSlice: slices to be used for ESF generation, e.g. 10 (use single slice); e.g. 10:15 (use 6 slices in total)
  % mask: voxels in `u` that were used for ESF calculation
    if nargin == 3 || isempty(iSlice); iSlice = 1:size(u,3); end
    u = u(:,:,iSlice);
    cents_ = o.cents(iSlice,:);
    msk = zeros(size(u),'logical');
    r = zeros(size(u));
    xyDim = [size(u,1) size(u,2)];

    for i = 1:size(u,3)
      [msk(:,:,i),r(:,:,i)] = mtf.genFanMask(xyDim, cents_(i,:), o.uSzScale, 'rRg', o.rRg*o.radius, 'thetaRg', thetaRg);
      esf = u(msk);
      esfAxs = r(msk); 
      [esf, esfAxs] = mtf.sortShiftRevertAxis(esf, esfAxs, -1);
    end
  end


  function [esfCel, esfAxsCel] = applyMult(o, nBin, u, thetaRg, varargin)
  % Calculate multiple ESFs and their axes (in voxel), for errorbar calculation
  % nBin: number of realizations
  % divide thetaRg into multiple bins
  % alternative implementation, divide iSlice
    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;
    if isempty(thetaRg); thetaRg = [-pi pi]; end
    thetaRgs = mtf.divideRg_nBin(thetaRg, nBin);
    for i = 1:nBin
      [esfCel{i}, esfAxsCel{i}] = apply(o, u, thetaRgs(i,:), varargin{:});
    end
  end


  function [pSave] = getParameters(o)
    pList = {'cents', 'radius', 'uSzScale', 'rRg'};
    pSave = util.dotNames(o, pList);
  end
end
end
