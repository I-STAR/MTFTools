classdef (Abstract) SfCalc < handle & SetGet_user

methods (Abstract)
   [sf, sfAxs] = apply(o, u, varargin)
   [sfCel, sfAxsCel] = applyMult(o, u, varargin) % to generate error bar
   [] = saveParameters(o) % for reload fitting parameter (compare between different acquisition filter etc.)
end

end