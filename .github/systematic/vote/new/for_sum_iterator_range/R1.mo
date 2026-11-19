model R1
  Real x[3](each start = 1, each fixed = true);
  Real c[3];
equation
  der(x) = -x;
  for i in 1:3 loop
    c[i] = sum(x[k] for k in 1:i);
  end for;
end R1;
