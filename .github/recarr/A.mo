model A
  record R
    Real a;
  end R;
  function f
    input Real x;
    output R r[1];
  algorithm
    r[1] := R(a = x);
  end f;
  R ro[1];
equation
  ro = f(time);
end A;
