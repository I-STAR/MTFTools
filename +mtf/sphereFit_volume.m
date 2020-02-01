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
  if P.bDebug
    % figure; mprov(uPeri); 
  end

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

% From Alan Jennings, University of Dayton
function [Center,Radius] = sphereFit(X)
    % this fits a sphere to a collection of data using a closed form for the
    % solution (opposed to using an array the size of the data set). 
    % Minimizes Sum((x-xc)^2+(y-yc)^2+(z-zc)^2-r^2)^2
    % x,y,z are the data, xc,yc,zc are the sphere's center, and r is the radius

    % Assumes that points are not in a singular configuration, real numbers, ...
    % if you have coplanar data, use a circle fit with svd for determining the
    % plane, recommended Circle Fit (Pratt method), by Nikolai Chernov
    % http://www.mathworks.com/matlabcentral/fileexchange/22643

    % Input:
    % X: n x 3 matrix of cartesian data
    % Outputs:
    % Center: Center of sphere 
    % Radius: Radius of sphere
    % Author:
    % Alan Jennings, University of Dayton

    A=[mean(X(:,1).*(X(:,1)-mean(X(:,1)))), ...
        2*mean(X(:,1).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,1).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        mean(X(:,2).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,2).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        0, ...
        mean(X(:,3).*(X(:,3)-mean(X(:,3))))];
    A=A+A.';
    B=[mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,1)-mean(X(:,1))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,2)-mean(X(:,2))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,3)-mean(X(:,3))))];
    Center=(A\B).';
    Radius=sqrt(mean(sum([X(:,1)-Center(1),X(:,2)-Center(2),X(:,3)-Center(3)].^2,2)));
end





