classdef EsfCalc_Plane < mtf.SfCalc
properties
  locs
  p1 % slope 
  uSzScale = [1 1] % handles asymmetric element spacing, changes in voxSize(3) does not matter anyway
end
properties (Dependent)
  angPlane
end
properties (Hidden)
  bSameShift = 1
  pDrawFit = {'y*-','MarkerSize',2};
end

methods
  function o = EsfCalc_Plane(varargin)
    o.parseinput(varargin{:});
  end
  function [] = set.uSzScale(o, in)
    assert(isnumeric(in) && length(in) == 2);
    o.uSzScale = in;
  end


  function [] = fit(o, u)
    locsRaw = mtf.maxIntensityLoc(u, 1);
    [o.locs,o.p1] = mtf.adjustLineLoc_sameSlope(locsRaw, 'bSameShift', o.bSameShift);
  end


  function [] = showFit(o, u, nSlice)
  % nSlice: number of slices to visualize
    if nargin == 2 || isempty(nSlice)
      nSlice = size(u,3);
    end
    iSlice = fix(linspace(1, size(u,3), min(size(u,3), nSlice)));
    for i = iSlice
      figure; imagesc(u(:,:,i)); colormap gray; hold on; 
      plot(1:size(u,2), o.locs(:,i), o.pDrawFit{:});
      axis off
      axis equal
    end
  end


  function [esf, esfAxs] = apply(o, u, iSlice)
    if nargin == 2 || isempty(iSlice); iSlice = 1:size(u,3); end
    [esf, esfAxs] = apply_(o, u(:,:,iSlice), o.locs(:,iSlice));
  end


  function [esfCel, esfAxsCel] = applyMult(o, nBin, u, iSlice)
    if nargin == 3 || isempty(iSlice); iSlice = 1:size(u,3); end
    u = reshape(u(:,:,iSlice), size(u,1), []);
    locsFlat = o.locs(:,iSlice);
    locsFlat = locsFlat(:);

    binids = discretize(1:size(u,2), nBin);
    esfCel = cell(1, nBin); 
    esfAxsCel = esfCel;
    for i = 1:nBin
      idx = binids == i;
      [esfCel{i}, esfAxsCel{i}] = apply_(o, u(:,idx), locsFlat(idx));
    end  
  end


  function [esf, esfAxs] = apply_(o, u, locs)
    [esf, esfAxs] = mtf.oversampleCurves(u, locs);
    esfAxs = esfAxs * cosd(o.angPlane);
    [esf, esfAxs] = mtf.sortShiftRevertAxis(esf, esfAxs, -1);
  end


  function [] = saveParameters(o)
    pList = {'locs', 'p1', 'uSzScale'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
  function out = getangPlane(o)
    p1Scale = o.p1;
    p1Scale = p1Scale * o.uSzScale(1) / o.uSzScale(2);
    out = abs(atand(p1Scale));
  end
end


methods
  function out = get.angPlane(o)
    out = o.getangPlane();
  end
end

end