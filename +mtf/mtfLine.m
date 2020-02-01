function out = mtfLine(ax, lineWidth)
% One easy way to check your implementation, when `lineWidth` is the same as dSize ... sinc
% should be ~0.6 at Nyquist...

% Normally used in slit etc. 
% e.g. Corgi phantom has 4 slits, whose lineWidth are: 0.1, 0.15, 0.2, 0.25 mm
  a = lineWidth/2/0.5; % a in rect(at), https://en.wikipedia.org/wiki/Rectangular_function
  out = sinc(a*ax);
end