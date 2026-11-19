model J
  Real x[2](start = {1, 2}, each fixed = true);
  Real m = max(x);
equation
  der(x) = {-m, -x[2]};
end J;
