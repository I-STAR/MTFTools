function out = mtfLine(ax, lineWidth)
% MTF for a line/slit
% lineWidth: width of line/slit in mm
  a = lineWidth/2/0.5;
  out = sinc(a*ax);
end