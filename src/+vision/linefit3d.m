function [xyzn, xfit, yfit] = linefit3d(xyz)
  r = mean(xyz);
  xyz = bsxfun(@minus,xyz,r);
  [~,~,V] = svd(xyz,0);
  xfit = @(z_fit) r(1)+(z_fit-r(3))/V(3,1)*V(1,1);
  yfit = @(z_fit) r(2)+(z_fit-r(3))/V(3,1)*V(2,1);

  z = xyz(:,3)+r(3);
  xyzn = [xfit(z) yfit(z) z];
end