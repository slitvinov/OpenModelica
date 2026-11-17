model E
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
equation
  der(x) = 1;
  when {x >= 0.5, sample(0.5, 1)} then
    n = pre(n) + 1;
  end when;
end E;
