model NI
  Integer n(start = 0, fixed = true);
  Real x(start = 0, fixed = true);
equation
  der(x) = 1;
  when not initial() then
    n = pre(n) + 1;
  end when;
end NI;
