function [msk] = segnd_th(u, th)
% Simple threshold based segmentation in nD
  if th > 0
    msk = u > th; 
  elseif th <= 0
    msk = u < -th;
  else
    assert(ischar(th));
    msk = imbinarize(u, th);
  end
  msk = vision.bwareafilt_nd(msk, 1); % largest connected component
  msk = imfill(msk,'holes'); % fill holes
end
