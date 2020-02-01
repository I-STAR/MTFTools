function [coors, h] = findWire(u, varargin)
% find wires (typical usage: Harp phantom)
% coors: Nx2, in mat convention
  P = inputParser;
  addOptional(P, 'bDebug', 0, @isnumeric);
  addOptional(P, 'nWires', 25, @isnumeric);
  addOptional(P, 'fh_Binarize', @(x) imbinarize(x, 'adaptive'), @isfh);
  % four confusing rods in the FOV (Harp phantom)
  addOptional(P, 'rmLastFour', 0, @isnumeric);
  parse(P, varargin{:});
  P = P.Results;
  
  uB = P.fh_Binarize(u);
  sz = size(uB);
  uB = croparrayto(uB, fix(0.95*sz));
  uB = padarrayto(uB, sz);
  
  % Largest one will be one
  [L, ~] = bwlabel(uB);
  stats = regionprops(L,'Centroid','Area');  
  if P.rmLastFour
    [~,idx] = sort([stats.Area]);
    stats = stats(idx(1:end-4));
  end

  % if P.bDebug
    % one of the archived debug method
    % RGB = label2rgb(L);
    % figure, imshow(RGB, []); title(['Number of labels: ', num2str(length(L))]);
  % end
  
  if length(stats) ~= P.nWires
    figure, imshow(uB,[]);
    disp(['nWire detected: ', num2str(length(stats))]);
    error('Error. Wrong number of wires');
  end
  
  coors = zeros(P.nWires, 2);
  for i = 1:size(coors,1)
    % Centroid is in mesh convention
    coors(i,:) = fliplr(stats(i).Centroid);
  end

  if P.bDebug
    h = figure; imshow(u, []); hold on;
    plot(coors(:,2), coors(:,1), '*y', 'MarkerSize', 1);
  end
end
