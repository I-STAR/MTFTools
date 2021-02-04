classdef (Abstract) SfCalc < handle & matlab.mixin.SetGetExactNames

properties
  pPath
end

methods (Abstract)
  [sf, sfAxs] = apply(o, u, varargin)
  [sfCel, sfAxsCel] = applyMult(o, u, varargin) % to generate error bar
  [] = saveParameters(o) % for reload fitted parameter (e.g. to compare different datasets)
end


methods (Access = protected)
  function [] = parseinput(o, varargin)
    if length(varargin) == 1 && ischar(varargin{1})
      % load from existing parameter set
      assert(isfile(varargin{1}), 'Error. pPath not found.');
      o.set(io.forceLoadMat(varargin{1}));
      o.pPath = varargin{1};
    elseif ~isempty(varargin)
      o.set(varargin{:});
    end
  end

  function [] = saveParametersList(o, pList)
    assert(iscell(pList));
    pSave = util.dotNames(o, pList);
    save(o.pPath, 'pSave');
  end
end

end