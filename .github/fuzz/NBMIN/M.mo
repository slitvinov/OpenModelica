model M
  Real x(min = 1, start = 1);
  Real y(max = 1, start = 1);
  Real z(min = 0, start = 1, fixed = true);
equation
  x^2 = 0.25;
  y^2 = 4;
  der(z) = -1;
end M;
