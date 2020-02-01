classdef EsfCalc_Wedge < mtf.SfCalc
% Measurement angle hard coded as 45 degree
% See also `EsfCalc_WedgeVAng`, more general
properties
  pPath
  bbox
  nSlice = 10
  locs
  p1
  fhDim
end

methods
  function obj = EsfCalc_Wedge(varargin)
    if length(varargin) == 1 && ischar(varargin{1})
      % load from pre-tested parameter
      obj.setc(forceLoadMat(varargin{1}));
      obj.pPath = varargin{1};
    else
      obj.setc(varargin{:});
    end
  end

  function [u] = testPre(o, u, varargin)
    o.setc(varargin{:});
    [u] = permuteCrop(o, u);
    figure, mprov(u);
  end
  function [] = testFit(o, u)
    [o.locs,o.p1,p2,~] = mtf.findLineLoc(u, 'bDebug', 1, ...
      'fh_loc', @mtf.maxIntensityLoc_edge, 'bWarn', 1);
    figure, plot(p2, '-*');
    title(['ang: ', num2str(atand(o.p1))]);
  end
  function [esf, esfAxs] = apply(o, u, varargin)
    [u] = permuteCrop(o, u);
    [esf, esfAxs] = mtf.oversampleCurves(u, o.locs, 45); % so now we are in mm...
  end

  function [esfCel, esfAxsCel] = applyMult(o, u, nBin, varargin)
    [u] = permuteCrop(o, u);
    
    celSz = floor(size(u,2)/(nBin));
    dimDivide = repmat(celSz,[1 nBin-1]);
    dimDivide = [dimDivide size(u,2)-sum(dimDivide)];
    
    uCel = mat2cell(u, size(u,1), dimDivide, size(u,3));
    locCel = mat2cell(o.locs, dimDivide, size(o.locs,2));
    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;
    
    for i = 1:nBin
      [esfCel{i}, esfAxsCel{i}] = mtf.oversampleCurves(uCel{i}, locCel{i}, 45);
    end  
  end

  function [u] = permuteCrop(o, u)
    if ~isempty(o.fhDim)
      u = o.fhDim(u);
    end
    u = cropbbox(u, o.bbox);
    u = cenSlice(u, o.nSlice);
  end

  function [] = saveParameters(o)
    pList = {'bbox', 'nSlice', 'locs', 'p1', 'fhDim'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end
end