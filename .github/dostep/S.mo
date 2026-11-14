package S
  model M
    parameter Integer n;
    discrete Real d[n];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x;
    when initial() then
      d = fill(1.0, n);
    end when;
  end M;
  model M1 = M(n = 1);
  model M10000 = M(n = 10000);
  model M50000 = M(n = 50000);
end S;
