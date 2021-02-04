classdef EsfCalc_Sphere < mtf.SfCalc
properties
  cent
  radius
  uSzScale = [1 1 1]
  rRg = [0.4 1.6] % empty: use the entire radial length
end

properties (Hidden)
  bTruncateTopBottom = 1
  pDraw = {'Color','y','LineWidth',1}
  bMultForceSameLength = 0
end

methods
  function o = EsfCalc_Sphere(varargin)
    o.parseinput(varargin{:});
  end


  function [] = fit(o, uBinary)
    [o.cent, o.radius] = vision.sphereFit_volume(uBinary, o.uSzScale, 0, o.bTruncateTopBottom);
  end


  function [] = showFit(o, u, nSlice)
  % nSlice: number of slices to visualize
    if nargin == 2 || isempty(nSlice)
      nSlice = size(u,3);
    end
    iSlice = fix(linspace(1, size(u,3), min(size(u,3), nSlice)));
    for i = iSlice
      rDraw = sqrt(o.radius^2 - ( (o.cent(3) - i) * o.uSzScale(3)/o.uSzScale(1) )^2);
      centDraw = [o.cent(1) o.cent(2)];
      if isreal(rDraw)
        figure; imshow(u(:,:,i), []); hold on;
        vision.drawcirc_scaler(centDraw, rDraw, 'pDraw', o.pDraw, 'dSize', o.uSzScale(1:2));
      end
    end
  end


  function [esf, esfAxs] = apply(o, u, varargin)
    [msk,r, ~] = mtf.genConeMask(size(u), o.cent, o.uSzScale, 'rRg', o.rRg*o.radius, varargin{:});
    [esf, esfAxs] = o.esfGenSingle(u, r, msk);
  end


  function [esfCel, esfAxsCel] = applyMult(o, nBin, u, varargin)
    [msk, r, theta] = mtf.genConeMask(size(u), o.cent, o.uSzScale, 'rRg', o.rRg*o.radius, varargin{:});
    [esfCel, esfAxsCel] = o.esfGenMult(u, r, theta, msk, nBin); 
  end


  function [esfCel, esfAxsCel] = esfGenMult(o, u, r, theta, msk, nBin)
    thetaMasked = theta(msk);
    thetas = linspace(min(thetaMasked(:)), max(thetaMasked(:)), nBin+1);

    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;
    for i = 1:nBin
      thetaMaskNew = theta >= thetas(i) & theta < thetas(i+1);
      mskNew = msk & thetaMaskNew;
      [esfCel{i}, esfAxsCel{i}] = o.esfGenSingle(u, r, mskNew);
    end
    if o.bMultForceSameLength
      [esfCel, esfAxsCel] = mtf.forceSfSameLength(esfCel, esfAxsCel, nBin);
    end
  end


  function [] = saveParameters(o)
    o.saveParametersList({'cent', 'radius', 'uSzScale', 'rRg'});
  end
end

methods (Static)
  function [esf, esfAxs] = esfGenSingle(u, r, msk)
    esf = u(msk);
    esfAxs = r(msk); 
    [esf, esfAxs] = mtf.sortShiftRevertAxis(esf, esfAxs, -1);
  end
end
end
