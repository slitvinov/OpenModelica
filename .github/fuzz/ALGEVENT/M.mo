model M
  Real y;
  Integer i(start = 0, fixed = true);
algorithm
  y := time;
  if y > 0.5 then
    i := 1;
  end if;
  y := 0;
end M;
model C "M without the last statement"
  Real y;
  Integer i(start = 0, fixed = true);
algorithm
  y := time;
  if y > 0.5 then
    i := 1;
  end if;
end C;
