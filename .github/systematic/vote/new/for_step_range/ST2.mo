model ST2 "only the 1:2:n loop, odd n"
  parameter Integer n = 5;
  Real z[n](each start = 0.5, each fixed = true);
equation
  for i in 1:2:n loop
    der(z[i]) = -z[i];
  end for;
  for i in 2:2:n loop
    der(z[i]) = -z[i] + z[i - 1];
  end for;
end ST2;
