function [lineInt, lLsf] = vol2LineInt(u, theta)
% use non-interpolation row/column summation for theta = 0 or theta = 90
% for other angles --> use radon transform method shipped with matlab
  if theta == pi/2
    lineInt = squeeze(sum(u, 2))';
    lLsf = size(u,2); % length for one lsf
  elseif theta == 0
    lineInt = squeeze(sum(u, 1))';
    lLsf = size(u,1); % length for one lsf
  else
    theta = rad2deg(theta);
    temp = radon(u(:,:,1), theta);
    lLsf = length(temp);
    lineInt = zeros(size(u,3), lLsf);
    for i = 1:size(u,3)
      lineInt(i,:) = radon(u(:,:,i), theta);
    end   
  end
  lineInt = lineInt';
end