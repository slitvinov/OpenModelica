model K
  Real x[2](each start = 1, each fixed = true);
  Real m = max(x[1], x[2]);
equation
  der(x) = {m, 0};
end K;
