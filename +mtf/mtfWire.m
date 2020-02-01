function out = mtfWire(ax, dWire)
% ax: mtf axis (frequency, only the positive part)
% dWire: diameter of the wire (normally in mm)

  % possible ref: https://web.eecs.umich.edu/~fessler/course/516/l/c-tomo.pdf
  % you can also find a demo file at ../Test_MTF_Wire/demo_bessel_sinc.m
  
  % jinc: first order bessel divided by axis
  out = besselj(1,ax.*(dWire)*pi) ./ (ax.*(dWire)*pi);
  out(1) = 0.5; % different than sinc --> jinc should be zero (l'hospital) at origin
  out = abs(out * 2);
end