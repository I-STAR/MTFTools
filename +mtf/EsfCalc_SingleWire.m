classdef EsfCalc_SingleWire < mtf.SfCalc
% see also `EsfCalc_Harp` (multiple wires)
properties
  pPath
  
  coor
  wireDirection
  szUse
  
  loc % fitting parameter for the wire

  fh_Binarize = @(x) bwareaopen(imbinarize(x/max(x(:))), 1)
end

methods
  function obj = EsfCalc_SingleWire(varargin)
    if length(varargin) == 1 && ischar(varargin{1})
      % load from pre-tested parameter
      obj.setc(forceLoadMat(varargin{1}));
      obj.pPath = varargin{1};
    else
      obj.setc(varargin{:});
    end
  end
  function [] = testFindWire(o, u, varargin)
    o.setc(varargin{:});
    uCen = cenSlice(u);
    [o.coor, ~] = mtf.findWire(uCen,'bDebug',1,'fh_Binarize',o.fh_Binarize,...
       'nWires',1,'rmLastFour',0);
  end
  function [] = mipShowWire(o, u, sz)
    assert(~isempty(o.coor));
    uSave1 = o.getMip(u, o.coor, 1, sz);
    uSave2 = o.getMip(u, o.coor, 2, sz);

    figure, imdisp(uSave1);
    figure, imdisp(uSave2);
  end
  function [] = fit(o, u, direction, sz)
    uSv = o.getMip(u, o.coor, direction, sz);
    figure, imdisp(uSv);
    o.set('wireDirection', direction, 'szUse', sz);

    [o.loc,p1] = mtf.findLineLoc(uSv, 'bDebug', 1, 'fh_loc', @mtf.maxIntensityLoc_line);
    disp(['Wire angle: ', num2str(atand(p1))]);
  end

  function [esf, esfAxs] = apply(o, u)
    uMip = o.getMip(u, o.coor, o.wireDirection, o.szUse);
    [esf, esfAxs] = mtf.oversampleCurves(uMip, o.loc);
  end

  function [esfCel, esfAxsCel] = applyMult(o, u, nBin)
    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;
   
    uMip = o.getMip(u, o.coor, o.wireDirection, o.szUse);
    [uCel, locCel] = mtf.dim2Divide(uMip, nBin, o.loc);

    for j = 1:nBin
      [esfCel{j}, esfAxsCel{j}] = mtf.oversampleCurves(uCel{j}, locCel{j});
    end
  end

  function [u] = permuteCrop(o, u)
    u = permute(u, [3 1 2]);
    u = cropbbox(u, o.bbox);
    u = cenSlice(u, o.nSlice);
  end

  function [] = saveParameters(o)
    pList = {'coor', 'wireDirection', 'szUse', 'loc'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end

methods (Static)
  function out = getMip(u, coor, direction, sz)
    bbox = cen2bbox([coor fix(size(u,3)/2)], sz);
    uWire = cropbbox(u, bbox);
    out = squeeze(sum(uWire,direction));
    % out = rot90(squeeze(sum(uWire,direction)));
  end
end
end