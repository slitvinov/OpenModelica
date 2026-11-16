model C1
  Real y;
  Real g = if time > 0.5 then 1 else -1;
equation
  y = (if y > 0 then 0.5*y else 0.25*y) + g;
end C1;
