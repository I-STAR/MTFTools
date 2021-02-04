function [msk] = seg2d_th(u, th)
% Simple threshold based segmentation in 2D
  if th > 0
    msk = u > th; 
  elseif th <= 0
    msk = u < -th;
  else
    assert(ischar(th));
    msk = imbinarize(u, th);
  end
  msk = bwareafilt(msk,1);
  msk = imfill(msk,'holes');
end
