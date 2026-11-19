model IR2 "same without the block"
  Integer i = if time > 0.5 then 1 else 0;
  Real y;
  Real x(start = 0, fixed = true);
equation
  y = i;
  der(x) = y;
end IR2;
