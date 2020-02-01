classdef EsfCalc_SingleCircle < mtf.SfCalc
properties
  pPath
  cent
  radius
end

properties
  th
  rmSmall
end

methods
  function obj = EsfCalc_SingleCircle(varargin)
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
    uBinary = u > o.th; 
    uBinary = bwareaopen(uBinary,o.rmSmall);
    [o.cent, o.radius] = mtf.circFit_volume(uBinary);

    h = figure; imshow(u, []);
    figure, imshow(uBinary, []);
    roi.drawCirc(o.cent, o.radius, 'handle', h);
  end
  function [esf, esfAxs] = apply(o, u)
    [msk,r, ~] = mtf.genAxialMask_2d(size(u), o.cent, 'rRange', [0.4 1.6]*o.radius);

    esf = u(msk);
    esfAxs = r(msk); 
    esf = max(esf(:)) - esf;
    [esf, esfAxs] = mtf.sortShiftAxis(esf, esfAxs);
  end
  function [esfCel, esfAxsCel] = applyMult(o, u, nBin)
    [msk,r,theta] = mtf.genAxialMask_2d(size(u), o.cent, 'rRange', [0.4 1.6]*o.radius);
    [esfCel, esfAxsCel] = o.esfGenMult(u, r, theta, msk, nBin);  
  end
  function [] = saveParameters(o)
    pList = {'cent', 'radius'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end

methods (Static)
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

    %%% make sure all error bar realization has the same length
    lengthUse = min(axsLength);
    for i = 1:nBin
      esfCel{i} = croparrayto(esfCel{i}, lengthUse);
      esfAxsCel{i} = croparrayto(esfAxsCel{i}, lengthUse);
    end
  end
end


end