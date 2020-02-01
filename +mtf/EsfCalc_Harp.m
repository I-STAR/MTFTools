classdef EsfCalc_Harp < mtf.SfCalc
properties
  pPath
  coors
  idWireUse
  wireDirection
  szUse
  locs
  fh_Binarize = @(x) bwareaopen(imbinarize(x/max(x(:))), 1)
  nWireTotal = 25
  bRmLastFour = 0
end

methods
  function obj = EsfCalc_Harp(varargin)
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
    [coor, ~] = mtf.findWire(uCen,'bDebug',1,'fh_Binarize',o.fh_Binarize,...
       'nWires',o.nWireTotal,'rmLastFour',o.bRmLastFour);
    
    coorSort = zeros(1, size(coor,1));
    for i = 1:size(coor,1)
      coorSort(i) = coor(i,1)*size(u,2) + coor(i,2);
    end
    [~, idx] = sort(coorSort);
    o.coors = coor(idx,:);
  end

  function [] = mipShowWires(o, u, sz)
    assert(~isempty(o.coors));
    uSave1 = cell(1, size(o.coors,1));
    uSave2 = cell(1, size(o.coors,1));
    for i = 1:size(o.coors,1)
      uSave1{i} = o.getMip(u, o.coors(i,:), 1, sz);
      uSave2{i} = o.getMip(u, o.coors(i,:), 2, sz);
    end
    figure, imdisp(uSave1);
    figure, imdisp(uSave2);
  end

  function [] = chooseWireAndFit(o, u, ids, directions, sz)
    uSv = cell(1, length(ids));
    for i = 1:length(ids)
      uSv{i} = o.getMip(u, o.coors(ids(i),:), directions(i), sz);
    end
    figure, imdisp(uSv);
    o.set('idWireUse', ids, 'wireDirection', directions, 'szUse', sz);

    % now do the fit
    o.locs = cell(1, length(uSv));
    for i = 1:length(uSv)
      [o.locs{i},p1] = mtf.findLineLoc(uSv{i}, 'bDebug', 1, 'fh_loc', @mtf.maxIntensityLoc_line);
      disp(['Wire angle: ', num2str(atand(p1))]);
    end
  end

  function [esf, esfAxs] = apply(o, u, idWire)
    if nargin == 2; idWire = (1); end
    % -1: use all wire
    if idWire == -1; idWire = 1:length(o.idWireUse); end

    if isscalar(idWire)
      uMip = o.getMip(u, o.coors(o.idWireUse(idWire),:), o.wireDirection(idWire), o.szUse);
      [esf, esfAxs] = mtf.oversampleCurves(uMip, o.locs{idWire});
    else
      for i = 1:length(idWire)
        uMip = o.getMip(u, o.coors(o.idWireUse(idWire(i)),:), o.wireDirection(idWire(i)), o.szUse);
        [esf{i}, esfAxs{i}] = mtf.oversampleCurves(uMip, o.locs{idWire(i)}); %#ok
      end
    end
  end

  function [esfCel, esfAxsCel] = applyMult(o, u, nBin, idWire)
  % total number of bins ... will be distributed across used wires
    if idWire == -1; idWire = 1:length(o.idWireUse); end  
    esfCel = cell(1, nBin);
    esfAxsCel = esfCel;
  
    nBins = repmat(floor(nBin / length(idWire)), [1 length(idWire)-1]);
    nBins = [nBins nBin - sum(nBins)];  

    cnt = 1;
    for i = 1:length(idWire)
      nBinEach = nBins(i);
      id = idWire(i);
      uMip = o.getMip(u, o.coors(o.idWireUse(id),:), o.wireDirection(id), o.szUse);
      loc = o.locs{id};

      [uCel, locCel] = mtf.dim2Divide(uMip, nBinEach, loc);
      for j = 1:nBinEach
        [esfCel{cnt}, esfAxsCel{cnt}] = mtf.oversampleCurves(uCel{j}, locCel{j});
        cnt = cnt + 1;
      end
    end
  end

  function [u] = permuteCrop(o, u)
    u = permute(u, [3 1 2]);
    u = cropbbox(u, o.bbox);
    u = cenSlice(u, o.nSlice);
  end

  function [] = saveParameters(o)
    pList = {'coors', 'idWireUse', 'wireDirection', 'szUse', 'locs'};
    pSave = struct;
    for i = 1:length(pList)
      pSave.(pList{i}) = o.(pList{i});
    end 
    save(o.pPath, 'pSave');
  end
end

methods (Static)
  function out = getMip(u, coor, direction, sz)
  % @@@TODO --> direction only supports dim1 or dim2 (not arbitrary one, through radon function in MATLAB)
  % Implemented here `vol2LineInt`, but I am not sure I trust non-orthogonal direction (@@@ISSUE)
    bbox = cen2bbox([coor fix(size(u,3)/2)], sz);
    uWire = cropbbox(u, bbox);
    out = squeeze(sum(uWire,direction));

    % other display direction
    % out = rot90(squeeze(sum(uWire,direction)));
  end
end

end