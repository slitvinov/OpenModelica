model S
  Real x;
equation
  (if time > 0.5 then 1 else 2) = der(x) + x;
end S;
