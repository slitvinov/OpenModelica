model EN "for over an enumeration type with Integer(c) in the body"
  type C = enumeration(Red, Green, Blue);
  parameter Real w[C] = {1.9, 1.5, 1.3};
  Real x[C](each start = 1, each fixed = true);
equation
  for c in C loop
    der(x[c]) = -w[c]*x[c] + Integer(c)*cos(time);
  end for;
end EN;
