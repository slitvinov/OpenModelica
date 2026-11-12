model B
  Real x(start = 1, fixed = true);
  Real a[1, 2, 1];
algorithm
  for i in 1:2 loop
    a[1, i, :] := {x};
  end for;
equation
  der(x) = -sum(a);
end B;
