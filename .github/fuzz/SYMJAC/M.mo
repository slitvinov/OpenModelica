model M
  Real x[2];
  Real m = max(x);
equation
  der(x) = {m, 0};
end M;
