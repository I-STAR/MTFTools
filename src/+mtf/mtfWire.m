function out = mtfWire(ax, dWire)
% Used to calculate MTF from a 3D wire
% dWire: diameter of the wire (mm)
  % jinc: first order bessel divided by axis
  out = besselj(1,ax.*(dWire)*pi) ./ (ax.*(dWire)*pi);
  out(1) = 0.5; % different than sinc --> jinc should be zero (l'hospital) at origin
  out = abs(out * 2);
end