model P3
  Real s1;
  parameter Real x1 = 0.0;
  Boolean b1 = true;
  Real x2;
equation
  der(x2) = integer(x1);
algorithm
  s1 := mod(time, 0.489);
end P3;
