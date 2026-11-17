model B
  record R
    Real a;
    Real b;
  end R;
  function f
    input Real x[:];
    output R r[size(x, 1)];
  algorithm
    for i in 1:size(x, 1) loop
      r[i] := R(a = x[i]^2, b = -x[i]);
    end for;
  end f;
  R ro[2];
  Real x(start = 0, fixed = true);
equation
  ro = f({sin(time), cos(time)});
  der(x) = ro[1].a + ro[2].b;
end B;
