model M
  Real x(start = 1, fixed = true);
  Real y;
  Real z;
equation
  der(x) = 1;
  der(y) = z;
  y = noEvent(mod(x, 6.28));
end M;
