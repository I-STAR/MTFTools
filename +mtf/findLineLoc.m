function [out,p1mean,p2s_eqSpace,outRaw] = findLineLoc(in, varargin)
% Inputs: 
%   in, should be line images (lines go along dim1, multiple realizations in dim2 and dim3)
% Outputs: 
%   out, line loc in dim2 x line loc in dim3
% Notes:
% 1. you can use line images with empty column (weights used)

  P = inputParser;
  addParameter(P, 'fh_loc', [], @(x) isempty(x) || isfh(x)); 
  addParameter(P, 'bDebug', 0, @isloginum); % show line for each slice (dim3)
  addParameter(P, 'bWarn', 0, @isloginum); 
  parse(P, varargin{:});
  P = P.Results;

  out = zeros([size(in,2) size(in,3)]);
  outRaw = out; % raw --> without fitting
  p1s = zeros(1,size(in,3)); % a bunch of p1 (fitting parameter for one line)
  p2s = p1s;
  %%% get raw locations
  for i = 1:size(in,3)
    l = in(:,:,i);  
    if isempty(P.fh_loc) % default detection method for edge
      idx = mtf.maxIntensityLoc_edge(l);
    else % e.g: maxLineIntensityLoc_line
      idx = P.fh_loc(l);
    end
    outRaw(:,i) = idx;
  end

  %%% first round of fitting
  for i = 1:size(in,3)
    idx = outRaw(:,i);
    % generate a weight vector to ignore empty edges (i.e. roi is too large)
    lineFit = fit((1:length(idx))', idx, 'poly1', 'Weight', genWeight(idx, size(in,1)));
    p1s(i) = lineFit.p1;
  end
  p1mean = mean(p1s);

  %%% second round of fitting
  ft = fittype('n*x + p2','problem','n');
  for i = 1:size(in,3)
    idx = outRaw(:,i);
    lineFit = fit((1:length(idx))', idx, ft, 'problem', p1mean, 'StartPoint', 0, ...
                  'Weight', genWeight(idx, size(in,1)));
    p2s(i) = lineFit.p2;
  end
  p2mean = mean(p2s);
  if length(p2s) > 1
    p2diff = mean(diff(p2s));
    if p2diff == 0
      % no change at all --> i.e. no oversample in that dim-3 (which is not a good sign)
      if P.bWarn; warning('Warning. No over-sample detected in `z` direction'); end
      p2s_eqSpace = p2s;
    else
      p2s_eqSpace = 0:p2diff:(p2diff*(length(p2s)-1));
      p2s_eqSpace = p2mean + p2s_eqSpace - mean(p2s_eqSpace);
    end
  else
    p2s_eqSpace = p2mean;
  end

  %%% third round --> generate actual fitted locations
  for i = 1:size(in,3)
    lineFit = polyval([p1mean, p2s_eqSpace(i)], 1:length(idx));
    out(:,i) = lineFit';
  end
  
  % with imagesc --> like a flipud as compared with direct imshow
  if P.bDebug
    figure; hold on; %@@@EXP: if you do not hold on here, axis will be defined purely by imshow (no negative)
    for i = 1:size(in,3)
      subplot(1,size(in,3),i);
      % imshow(in(:,:,i),[]); hold on; %@@@EXP: the correct `hold on` place 
      imagesc(in(:,:,i)); hold on; %@@@EXP: for small 2d wire display, imagesc is much better
      plot(1:size(in,2), out(:,i), '*', 'MarkerSize', 2);
      axis off
    end
  end
end

function [out] = genWeight(idx, szDim1)
  out = ~(idx == 1 | idx == szDim1);
end
