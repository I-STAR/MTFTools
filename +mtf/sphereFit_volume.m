function [cent, radius] = sphereFit_volume(u, varargin)
% run sphere fitting on volume data
% using ind2sub --> mat convention, therefore, cent (output) is in mat convention as well

% cent3 is rescaled back
% helper function using sphereFit (which only works for countour data)

% @@@ISSUE, asymmetric voxel size in axial plane (should be trivial to add)

  P = inputParser;
  addOptional(P, 'dSize', [1 1 1], @isnumeric);
  addOptional(P, 'bDebug', 0, @isnumeric);
  % remove top and bottom (truncated sphere etc.)
  addOptional(P, 'bRmTopBottom', 0, @isnumeric);
  parse(P, varargin{:});
  P = P.Results;
  
  dSize = P.dSize;

  assert(islogical(u));
  uPeri = bwperim(u);
  if P.bRmTopBottom
    uPeri = uPeri(:,:,2:end-1);
  end
  if P.bDebug; figure; mprov(uPeri); end

  idx = find(uPeri); % find points in M
  [rr,cc,pp] = ind2sub(size(uPeri),idx); % sub indices
  pp = pp.*dSize(3)/dSize(1); % rescale third dimension, very important
  [cent,radius] = sphereFit([rr, cc, pp]);

  if P.bDebug
    figure;
    scatter3(cc,rr,pp,25,pp,'*'); %points
    hold on; % hold
    daspect([1,1,1]); % equal axis so a sphere looks like a sphere
    [Base_rr,Base_cc,Base_pp] = sphere(20);
    surf(radius*Base_rr+cent(2),...
        radius*Base_cc+cent(1),...
        radius*Base_pp+cent(3),'faceAlpha',0.3,'Facecolor','c')
    axis tight;
  end
  
  cent(3) = cent(3)/dSize(3)*dSize(1);
  if P.bRmTopBottom; cent(3) = cent(3) + 1; end
end





