model R
  parameter Real s = 1;
  Real x[3];
equation
  {{1, 2, 3}, {4, 5, 6}, {7, 8, 10}} * x = s * {1/3, 2/7, 5/11} * (1 + time);
end R;
