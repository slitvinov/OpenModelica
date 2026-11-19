model F
  parameter Real c = 2;
  Real x(start = 1, fixed = false);
  Real y(start = 1);
equation
  x = c;
  y = c;
end F;
