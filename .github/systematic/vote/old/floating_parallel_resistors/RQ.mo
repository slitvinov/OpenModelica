model RQ "same with plain equations: v = 4*i2, v = 100.4*i3, i2 + i3 = 0"
  Real v, i2, i3, P2, P3;
  Real x(start = 1, fixed = true);
equation
  v = 4*i2;
  v = 100.4*i3;
  i2 + i3 = 0;
  P2 = v*i2;
  P3 = v*i3;
  der(x) = -x;
end RQ;
