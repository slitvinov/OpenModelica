model M
  Real x[2](each start = 1, each fixed = true);
  Real m = max(x);
equation
  der(x) = {m, 0};
end M;
