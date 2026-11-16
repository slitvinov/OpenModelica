model SQ6
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = if x1 > 0 then x1 + 0.3*x1^2 else x1 - 0.3*x1^2;
end SQ6;
