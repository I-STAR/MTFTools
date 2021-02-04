function thetaRgs = divideRg_nBin(thetaRg, nBin)
  assert(length(thetaRg) == 2);
  thetas = linspace(thetaRg(1), thetaRg(2), nBin+1);
  thetaRgs = zeros(nBin, 2);
  for i = 1:nBin
    thetaRgs(i,:) = [thetas(i) thetas(i+1)];
  end
end