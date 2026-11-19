model J
  Real x(start = 0, fixed = true);
equation
  der(x) = integer(time + 2);
end J;
