model T
  parameter Real k = 1;
  Real x(start = 1, fixed = true);
equation
  der(x) = -k*x;
end T;
