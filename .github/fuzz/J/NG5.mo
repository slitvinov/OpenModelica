model NG5
  Real y;
  Real x(start = 0, fixed = true);
equation
  der(x) = 1;
  y = noEvent(if x > 10 then mod(x, 0.5) else x);
end NG5;
