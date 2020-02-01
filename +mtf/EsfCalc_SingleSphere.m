classdef EsfCalc_SingleSphere < mtf.SfCalc
properties
  pPath
  cent
  radius
  uSzScale = [1 1 1] 
end

properties
  th
  rmSmall % like 200 (< that voxel number to be removed)
  % used if voxSize is asymmetric (helical scan etc.)
  bTruncateTopBottom = 1
end

methods
  function obj = EsfCalc_SingleSphere(varargin)
    if length(varargin) == 1 && ischar(varargin{1})
      % load from pre-tested parameter
      obj.setc(forceLoadMat(varargin{1}));
      obj.pPath = varargin{1};
    else
      obj.setc(varargin{:});
    end
  end

  function [] = testFit(o, u, varargin)
    o.setc(varargin{:});
    nDebugSlice = 20;
    uBinary = u > o.th; 
    uBinary = bwareaopen(uBinary,o.rmSmall);

    % figure, mprov(uBinary);
    [o.cent, o.radius] = mtf.sphereFit_volume(uBinary, o.uSzScale, 1, o.bTruncateTopBottom);
    % can not be written into sphereFit_volume function (since binary input...)
    mtf.validateSphereFit2D(u, o.cent, o.radius, nDebugSlice, o.uSzScale); 
  end

  function [esf, esfAxs] = applyAxial(o, u, sliceRg)
    if nargin == 2; sliceRg = 0; end
    [msk,r, ~] = mtf.genAxialMask(size(u), o.cent, o.uSzScale, 'bDebug', 0, 'sliceRg', sliceRg, 'rRange', [0.4 1.6]*o.radius);
    [esf, esfAxs] = o.esfGenSingle(u, r, msk);  
  end
  function [esfCel, esfAxsCel] = applyAxialMult(o, u, nBin, sliceRg)
    if nargin == 3; sliceRg = 0; end
    [msk,r,theta] = mtf.genAxialMask(size(u), o.cent, o.uSzScale, 'bDebug', 0, 'sliceRg', sliceRg, 'rRange', [0.4 1.6]*o.radius);
    [esfCel, esfAxsCel] = o.esfGenMult(u, r, theta, msk, nBin);  
  end
  function [esf, esfAxs] = applyCone(o, u, coneRg)
    if nargin == 2; coneRg = [-10 10]; end
    [msk,r, ~] = mtf.genConeMask(size(u), o.cent, o.uSzScale, 'bDebug', 0, ...
                'coneRg', coneRg, 'rRange', [0.4 1.6]*o.radius);
    [esf, esfAxs] = o.esfGenSingle(u, r, msk);
  end
  function [esfCel, esfAxsCel] = applyConeMult(o, u, nBin, coneRg)
    if nargin == 3; coneRg = [-10 10]; end
    [msk,r, theta] = mtf.genConeMask(size(u), o.cent, o.uSzScale, 'bDebug', 0, ...
                'coneRg', coneRg, 'rRange', [0.4 1.6]*o.radius);
    [esfCel, esfAxsCel] = o.esfGenMult(u, r, theta, msk, nBin);  
  end

  function [esf, esfAxs] = apply(o, u, method, varargin)
    switch method
    case 'axial'
      [esf, esfAxs] = applyAxial(o, u, varargin{:});
    case 'cone'
      [esf, esfAxs] = applyCone(o, u, varargin{:});
    otherwise
      error('Error. Method not implemented.');
    end
  end
  function [esfCel, esfAxsCel] = applyMult(o, u, nBin, method, varargin)
    switch method
    case 'axial'
      [esfCel, esfAxsCel] = applyAxialMult(o, u, nBin, varargin{:});
    case 'cone'
      [esfCel, esfAxsCel] = applyConeMult(o, u, nBin, varargin{:});
    end
  end

  function [] = saveParameters(o)
    pList = {'cent', 'radius', 'uSzScale'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end

methods (Static)
  function [esf, esfAxs] = esfGenSingle(u, r, msk)
    esf = u(msk);
    esfAxs = r(msk); 
    esf = max(esf(:)) - esf;
    [esf, esfAxs] = mtf.sortShiftAxis(esf, esfAxs);
  end
  function [esfCel, esfAxsCel] = esfGenMult(u, r, theta, msk, nBin)
    thetas = linspace(-pi, pi, nBin+1);
    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;

    axsLength = zeros(1, nBin);
    for i = 1:nBin
      thetaMsk = theta >= thetas(i) & theta < thetas(i+1);
      mskComb = msk & thetaMsk;
      esf = u(mskComb);
      esfAxs = r(mskComb); 
      esf = max(esf(:)) - esf;
      [esfCel{i}, esfAxsCel{i}] = mtf.sortShiftAxis(esf, esfAxs);
      axsLength(i) = length(esfAxs);
    end

    lengthUse = min(axsLength);
    for i = 1:nBin
      esfCel{i} = croparrayto(esfCel{i}, lengthUse);
      esfAxsCel{i} = croparrayto(esfAxsCel{i}, lengthUse);
    end
  end
end
end