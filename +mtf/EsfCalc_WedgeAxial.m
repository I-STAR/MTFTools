classdef EsfCalc_WedgeAxial < mtf.SfCalc
properties
  pPath
  bbox
  iSlice
  locs
  p1
  fhDim
end

methods
  function obj = EsfCalc_WedgeAxial(varargin)
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
    [o.locs,o.p1,~,~] = mtf.findLineLoc(u, 'bDebug', 1, 'fh_loc', @mtf.maxIntensityLoc_edge);
    disp(['p1: ', num2str(o.p1)]);
  end
  function [esf, esfAxs] = apply(o, u)
    [u] = permuteCrop(o, u);
    [esf, esfAxs] = mtf.oversampleCurves(u, o.locs, 0); 
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
    u = u(:,:,o.iSlice);
    u = cropbbox(u, o.bbox);
  end

  function [] = saveParameters(o)
    pList = {'bbox', 'iSlice', 'locs', 'p1', 'fhDim'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end
end