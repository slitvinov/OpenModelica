model R
  Real u = if time < 0.5 then 1 else 0;
  Boolean b = u <= 0;
  Real x(start = 0, fixed = true);
equation
  der(x) = if b then 1 else 0;
end R;
