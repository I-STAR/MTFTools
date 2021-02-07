classdef EsfCalc_Wedge < mtf.EsfCalc_Plane
% See also `EsfCalc_Plane`


methods
  function o = EsfCalc_Wedge(varargin)
    o = o@mtf.EsfCalc_Plane(varargin{:});
  end
  function out = getangPlane(o)
    out = getangPlane@mtf.EsfCalc_Plane(o);
    if ~(out > 40 && out < 50)
      warning(['Warning. Wedge placement might be incorrect (ang: ', num2str(out), ').']);
    end
  end
end
end