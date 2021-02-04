if ~exist('setupLineControl__','var')
  setupLineControl__ = 1;
end
switch setupLineControl__
case 1
  clear; close all; addpath('../src'); addpath('./helpers');
case 2
  clearvars -except o__
  close all;
otherwise 
  error('Error. Unknown `setupLineControl__`');
end
clear setupLineControl__