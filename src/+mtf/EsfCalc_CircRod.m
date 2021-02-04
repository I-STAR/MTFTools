classdef EsfCalc_CircRod < mtf.SfCalc
properties
  cents % circle center for each slice (N*2)
  radius % circle radius (scalar, same for each slice)
  uSzScale = [1 1] % handles asymmetric element spacing
  rRg = [0.4 1.6] % empty: use the entire radial length
end
properties (Hidden)
  bLineFit3d = 1
  pDraw = {'Color','y','LineWidth',1}
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
  % u: volume 
  % thetaRg: range of theta (rad), e.g. [-pi pi]
  % iSlice: slices to be used for ESF generation, e.g. 10 (use single slice); e.g. 10:15 (use 6 slices in total)
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


  function [] = saveParameters(o)
    o.saveParametersList({'cents', 'radius', 'uSzScale', 'rRg'});
  end
end
end
