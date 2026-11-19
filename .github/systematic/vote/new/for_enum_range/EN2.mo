model EN2 "same without Integer(c)"
  type C = enumeration(Red, Green, Blue);
  parameter Real w[C] = {1.9, 1.5, 1.3};
  Real x[C](each start = 1, each fixed = true);
equation
  for c in C loop
    der(x[c]) = -w[c]*x[c] + cos(time);
  end for;
end EN2;
