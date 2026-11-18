model S
  Real x(start = 0, fixed = true);
  Real z(start = 0, fixed = true);
  Real out0, out1;
equation
  der(x) = 0.5;
  der(z) = cos(10*time);
  (out0, out1) = spatialDistribution(z, z, x, true, {0, 1}, {0, 0});
end S;
