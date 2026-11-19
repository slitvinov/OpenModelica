model P
  Real v1(start = 1), v2(start = 1), i1, i2;
equation
  1e4 - v1 = 1.2*i1 - 1.6*i2;
  0 - v2 = 1.2*i2 + 1.6*i1;
  v1*i1 + v2*i2 = 2.7e6;
  v2*i1 - v1*i2 = 0.9e6;
end P;
