function [output] = dotNamesFh(in, fNames, fhVal)
  assert(length(in) == 1);
  output = struct;

  fNames = util.tocell(fNames);

  for i = 1:length(fNames)
    n = fNames{i};
    try
      val = in.(n);
      if fhVal(val)
        output.(n) = val;
      end
    catch
      error(['Error. Field/Property name ', num2str(n), ' does not exist']);
    end
  end
end






