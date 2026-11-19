model CH "algorithm: when edge(b) then n := pre(n)+1; when change(n) then e := pre(e)+2 (in the same algorithm)"
  Real x(start = 0, fixed = true);
  discrete Integer n(start = 0, fixed = true);
  discrete Integer e(start = 0, fixed = true);
  Boolean b;
equation
  der(x) = 1;
  b = x > 0.3 + 0.5*pre(n);
algorithm
  when edge(b) then
    n := pre(n) + 1;
  end when;
  when change(n) then
    e := pre(e) + 2;
  end when;
end CH;
