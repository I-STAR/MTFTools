classdef EsfCalc_Irregular < mtf.SfCalc
% Assumes symmetric spacing
properties (Access = public)
  % e.g. {'Canny',[0.1 0.9],5}; 
  % or one can directly set `detectedEdge` 
  pEdge 
  nCurveSample % number of points along the detected edge
  profLength % search length
  nProfSample % number of points along that search path
end
properties (Access = public)
  detectedEdge
end
methods
  function o = EsfCalc_Irregular(varargin)
    o.parseinput(varargin{:});
  end


  function [] = fit(o, u)
  % `u` might need to be adjusted to be [0 1]
    eg = edge(u, o.pEdge{:});
    o.detectedEdge = eg;
  end


  function [] = showFit(o, u)
    %%% show edge
    eg = o.detectedEdge;
    figure; imdisp(u,[]); hold on;
    [x_,y_] = ind2sub(size(eg),find(eg==1));
    plot(y_,x_,'c*');

    %%% show esf composite
    h = figure; imdisp(u,[]);
    pComp = util.dotNamesFh(o, {'nCurveSample', 'profLength', 'nProfSample'}, @(x) ~isempty(x));
    pComp.bDebug = 1;
    pComp.gh = h;
    [lps1d, axs1d, ~, ~] = mtf.esfCompositeFromEdgeDetection(u,eg,pComp);
    figure; plot(axs1d,lps1d,'*');
  end


  function [esf, esfAxs] = apply(o, u)
    pComp = util.dotNamesFh(o, {'nCurveSample', 'profLength', 'nProfSample'}, @(x) ~isempty(x));
    [esf, esfAxs, ~, ~] = mtf.esfCompositeFromEdgeDetection(u,o.detectedEdge,pComp);
  end


  function [esfCel, esfAxsCel] = applyMult(o, nBin, u)
    pComp = util.dotNamesFh(o, {'nCurveSample', 'profLength', 'nProfSample'}, @(x) ~isempty(x));
    [~, ~, esf, esfAxs] = mtf.esfCompositeFromEdgeDetection(u,o.detectedEdge,pComp);
    esfCel = util.mat2cell_num(esf, [1 nBin]);
    esfAxsCel = util.mat2cell_num(esfAxs, [1 nBin]);
      
    for i = 1:nBin
      [esfCel{i}, esfAxsCel{i}] = mtf.sortShiftRevertAxis(util.flatten(esfCel{i}), util.flatten(esfAxsCel{i}), -1);
    end
  end


  function [pSave] = getParameters(o)
    pList = {'pEdge', 'uProcLimit', 'nCurveSample', 'profLength', 'nProfSample', 'detectedEdge'};
    pSave = util.dotNames(o, pList);
  end


  function [] = saveParameters(o)
    pSave = o.getParameters();
    save(o.pPath, 'pSave');
  end
end
end