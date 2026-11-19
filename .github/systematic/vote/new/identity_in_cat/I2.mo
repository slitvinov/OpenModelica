model I2 "same without cat: Real matrix plus identity"
  Real x(start = 1, fixed = true);
  Real E[2, 2] = x*identity(2);
equation
  der(x) = -x;
end I2;
