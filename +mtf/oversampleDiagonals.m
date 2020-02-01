function [curv, axs] = oversampleDiagonals(u, locs, varargin)
% ARCHIVED!!! see `oversampleCurves`
% used as a compare method (not nominal one) in wedge MTF
% locs, nCols x nSlids
% axs will start from 1
  P = inputParser;
  addParameter(P, 'fh_nDiag', @(x) floor(x(2)*1/4), @isfh); % default: 1/3 size dim2
  parse(P, varargin{:});
  P = P.Results;

  curv = [];
  axs = [];
  nDiag = P.fh_nDiag(size(u));
  baseCol = ceil(size(u,2)/2);
  
  for i = 1:size(u,3)
    for j = -nDiag:1:nDiag % both upper and lower diags
      curv_ = diag(u(:,:,i), j);
      curv = [curv; curv_]; %#ok
      axs_ = (1:length(curv_)) - mean(1:length(curv_)); % row vector
      axs_ = axs_ - 1*dis_45([baseCol locs(baseCol, i)], [baseCol+j locs(baseCol+j, i)]);
      axs = [axs; axs_']; %#ok
    end
  end
  [axs, idx] = sort(axs, 'ascend');
  curv = curv(idx);
  
  % make sure the axis starts from 1
  axs = axs - min(axs) + 1;
end

function [out] = dis_45(p1, p2)
% p1 and p2 should be 1x2 coor
% divide by 2: 1/2 diagonal (per pixel gap)
% sqrt(2): sampled on diagonal line
  out = (p2 - p1) * [1 1]' / sqrt(2) / 2;
end
