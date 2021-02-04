classdef LsfCalc_Slit < mtf.EsfCalc_Plane
methods
  function o = LsfCalc_Slit(varargin)
    o = o@mtf.EsfCalc_Plane(varargin{:});
  end


  function [] = fit(o, u)
    locsRaw = mtf.maxIntensityLoc(u, 0);
    [o.locs,o.p1] = mtf.adjustLineLoc_sameSlope(locsRaw, 'bSameShift', o.bSameShift);
  end


  function [esf, esfAxs] = apply_(o, u, locs)
    [esf, esfAxs] = mtf.oversampleCurves(u, locs);
    esfAxs = esfAxs * cosd(o.angPlane);
    [esf, esfAxs] = mtf.sortShiftRevertAxis(esf, esfAxs, 0);
  end
end
end