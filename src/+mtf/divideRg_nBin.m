function rgs = divideRg_nBin(rg, nBin)
% Divide the input range (`rg`, length 2 vector) into multiple ranges (`rgs`, N*2)
  assert(length(rg) == 2);
  thetas = linspace(rg(1), rg(2), nBin+1);
  rgs = zeros(nBin, 2);
  for i = 1:nBin
    rgs(i,:) = [thetas(i) thetas(i+1)];
  end
end