model S3
  Real x(start = 0, fixed = true);
  Boolean f(start = false, fixed = true);
  Integer n(start = 0, fixed = true);
equation
  der(x) = 1;
  when sample(0.1, 0.2) then
    f = not pre(f);
  end when;
equation
  when edge(f) or x > 1.3 then
    n = pre(n) + 1;
  end when;
end S3;
