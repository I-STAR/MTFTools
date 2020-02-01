classdef SetGet_user < matlab.mixin.SetGet
% slight modification from matlab.mixin.SetGet
  methods
    function [] = setc(obj, varargin)  
    % call normal `set` from `matlab.mixin.SetGet` first, then call use defined `setXXX` setter functions
    % setter functions does not have to be public
    % the order to which your setXXX parameters are inputted will be preserved

      % bMatch: this is a setter function
      [names, values, bMatch] = obj.setcInputParser(varargin{:}); 
      
      % added `torow` resolve the following MATLAB error: 
      % Value cell array handle dimension must match handle vector length
      obj.set( torow(names(~bMatch)), torow(values(~bMatch)) );
      
      namesMatch = names(bMatch);
      valuesMatch = values(bMatch);
      for i = 1:length(namesMatch)
        obj.(['set', namesMatch{i}])(valuesMatch{i}); 
      end
    end
    
    function [] = setcr(obj, varargin)   
    % reverse order, setter functions first, then `set` from `matlab.mixin.SetGet`
      [names, values, bMatch] = obj.setcInputParser(varargin{:});
      namesMatch = names(bMatch);
      valuesMatch = values(bMatch);
      for i = 1:length(namesMatch); obj.(['set', namesMatch{i}])(valuesMatch{i}); end
      obj.set( torow(names(~bMatch)), torow(values(~bMatch)) );
    end
  end
  
  methods (Access = private)
    function [names, values, bMatch] = setcInputParser(obj, varargin)
    % 1) name value pair, 2) name cell and value cell, or 3) structure
      methNames = builtin('methods', obj);
      methNames = methNames(cellfun(@(x) length(x) > 3 && strcmp(x(1:3), 'set'), methNames));
      
      [names, values] = getNamesValues(varargin{:});
      bMatch = cellfun(@(x) ismember(['set', x], methNames), names, 'UniformOutput', true);
    end
  end
end
