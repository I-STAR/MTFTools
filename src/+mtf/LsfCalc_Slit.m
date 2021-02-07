classdef LsfCalc_Slit < mtf.EsfCalc_Plane
% Calculate LSF from a slit (2D or 3D), resulting LSF would be perpendicular to that slit
%   so the result does not have to be axial MTF 
% See also `EsfCalc_Plane`
% u: lsf should be bell shaped (not the inverse) (so slit should be "bright")

methods
  function o = LsfCalc_Slit(varargin)
    o = o@mtf.EsfCalc_Plane(varargin{:});
  end


  function [] = fit(o, u)
  % Fit the slit
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