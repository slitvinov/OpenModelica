model D1
  Real x(start = 2), d(fixed = true);
equation
  d = der(x);
  der(x) = 1 - x;
end D1;
model D2
  Real x(start = 2), d(start = 0, fixed = true);
equation
  d = der(x);
  der(x) = 1 - x;
end D2;
