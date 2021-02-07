classdef (Abstract) SfCalc < handle & matlab.mixin.SetGetExactNames
% Base abstract class for spread function (2D/3D, ESF/LSF) calculation
properties
  pPath % path to store fitting parameters (like sphere center etc.)
end

methods (Abstract)
  % get spread function
  [sf, sfAxs] = apply(o, u, varargin) 
  % get multiple spread functions (in a cell array), to generate error bar
  [sfCel, sfAxsCel] = applyMult(o, u, varargin) 
  % get a structure of parameters to be saved, see `parseinput` and `saveParameters`
  [] = getParameters(o) 
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

  function [] = saveParameters(o)
    pSave = o.getParameters();
    assert(isstruct(pSave));
    save(o.pPath, 'pSave');
  end
end

end