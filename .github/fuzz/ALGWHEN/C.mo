model C
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
algorithm
  when x > 0.3 then
    n := 1;
  end when;
  when change(n) then
    e := 1;
  end when;
end C;
