classdef LsfCalc_Wire < mtf.LsfCalc_Slit
% Calculate axial LSF from a 3D wire
% Note:
%   - Use `LsfCalc_Slit` if the wire is already forward projected / radon transformed
%   - u: lsf should be bell shaped (not the inverse) (so wire should be "bright")
properties
  uSzScale3d = [1 1 1]
  % wire direction, can only be `[-pi -pi/2 0 pi/2 pi]`
  % for other directions, one can perform forward projection of the wire outside of this function, 
  %   and then use `LsfCalc_Slit`
  theta 
end


methods
  function [] = set.uSzScale3d(o, in)
    assert(isnumeric(in) && length(in) == 3);
    o.uSzScale3d = in;
  end


  function [] = set.theta(o, in)
    assert(ismember(in, [-pi -pi/2 0 pi/2 pi]));
    o.theta = in;
  end


  function o = LsfCalc_Wire(varargin)
    o = o@mtf.LsfCalc_Slit(varargin{:});
  end


  function [] = fit(o, u)
  % Fit wire for each slice
    lineInt = vol2LineInt(o, u);
    fit@mtf.LsfCalc_Slit(o, lineInt);
  end


  function [] = showFit(o, u, varargin)
  % Show fitting results
    lineInt = vol2LineInt(o, u);
    showFit@mtf.LsfCalc_Slit(o, lineInt, varargin{:});
  end


  function [varargout] = apply(o, u, varargin)
  % Calculate LSF and its axis (in voxel)
    lineInt = vol2LineInt(o, u);
    [varargout{1:nargout}] = apply@mtf.LsfCalc_Slit(o, lineInt, 1, varargin{:});
  end


  function [varargout] = applyMult(o, nBin, u, varargin)
  % Calculate multiple LSFs and their axes (in voxel), for errorbar calculation
  % nBin: number of realizations
    lineInt = vol2LineInt(o, u);
    [varargout{1:nargout}] = applyMult@mtf.LsfCalc_Slit(o, nBin, lineInt, varargin{:});
  end


  function [lineInt] = vol2LineInt(o, u)
  % Volume to line integral (line integration)
    theta_ = o.theta;
    if ismember(theta_, [-pi 0 pi])
      lineInt = squeeze(sum(u, 1));
      o.uSzScale = o.uSzScale3d([2 3]);
    elseif ismember(theta_, [-pi/2 pi/2])
      lineInt = squeeze(sum(u, 2));
      o.uSzScale = o.uSzScale3d([1 3]);
    else
      error('Error. `theta` value not supported'); 
    end
  end
end

end