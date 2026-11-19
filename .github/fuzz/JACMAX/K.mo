model K
  Real x[2](start = {1, 2}, each fixed = true);
  Real m = max(x[1], x[2]);
equation
  der(x) = {-m, -x[2]};
end K;
